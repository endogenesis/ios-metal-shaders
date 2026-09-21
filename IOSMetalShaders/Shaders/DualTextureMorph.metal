//
//  DualTextureMorph.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.09.2026.
//

#include <metal_stdlib>
using namespace metal;

struct MorphUniforms {
    uint width;
    uint height;
    uint fieldWidth;
    uint fieldHeight;
    float progress;
    float intensity;
    uint mode;
    uint padding;
};

float morphLuma(float3 color) {
    return dot(color, float3(0.2126, 0.7152, 0.0722));
}

float morphHash(float2 value) {
    return fract(sin(dot(value, float2(127.1, 311.7))) * 43758.5453);
}

// Match coarse 16x16 blocks before the visible pass. A small search is enough
// to make prominent edges travel toward their counterparts in the second scene.
kernel void morphCorrespondence(
    texture2d<float, access::read> source [[texture(0)]],
    texture2d<float, access::read> target [[texture(1)]],
    texture2d<float, access::write> field [[texture(2)]],
    constant MorphUniforms &uniforms [[buffer(0)]],
    uint2 tile [[thread_position_in_grid]]
) {
    if (tile.x >= uniforms.fieldWidth || tile.y >= uniforms.fieldHeight) { return; }

    int2 extent = int2(uniforms.width, uniforms.height) - 1;
    int2 center = min(int2(tile * 16u + 8u), extent);
    float bestScore = 1e9;
    int2 bestOffset = int2(0);

    for (int y = -8; y <= 8; y += 4) {
        for (int x = -8; x <= 8; x += 4) {
            int2 offset = int2(x, y);
            float score = float(x * x + y * y) * 0.00035;
            for (int sy = -1; sy <= 1; sy++) {
                for (int sx = -1; sx <= 1; sx++) {
                    int2 sampleOffset = int2(sx, sy) * 5;
                    uint2 a = uint2(clamp(center + sampleOffset, int2(0), extent));
                    uint2 b = uint2(clamp(center + sampleOffset + offset, int2(0), extent));
                    score += abs(morphLuma(source.read(a).rgb)
                        - morphLuma(target.read(b).rgb));
                }
            }
            if (score < bestScore) {
                bestScore = score;
                bestOffset = offset;
            }
        }
    }
    field.write(float4(float2(bestOffset), 0.0, 1.0), tile);
}

kernel void dualTextureMorph(
    texture2d<float, access::sample> source [[texture(0)]],
    texture2d<float, access::sample> target [[texture(1)]],
    texture2d<float, access::sample> field [[texture(2)]],
    texture2d<float, access::write> output [[texture(3)]],
    constant MorphUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }

    constexpr sampler linearSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    float2 size = float2(uniforms.width, uniforms.height);
    float2 uv = (float2(pixel) + 0.5) / size;
    float progress = clamp(uniforms.progress, 0.0, 1.0);

    if (progress <= 0.0) {
        output.write(source.sample(linearSampler, uv), pixel);
        return;
    }
    if (progress >= 1.0) {
        output.write(target.sample(linearSampler, uv), pixel);
        return;
    }

    float2 correspondence = field.sample(linearSampler, uv).rg / size;
    float noise = morphHash(floor(float2(pixel) / 3.0));
    float2 displacement = correspondence * uniforms.intensity;
    float threshold;

    if (uniforms.mode == 1u) { // Shards
        float2 cell = floor(float2(pixel) / 22.0);
        float angle = morphHash(cell) * 6.2831853;
        displacement += float2(cos(angle), sin(angle))
            * (0.06 + 0.07 * morphHash(cell + 11.0));
        threshold = 0.1 + 0.8 * morphHash(cell);
    } else if (uniforms.mode == 2u) { // Smoke
        float wave = sin(uv.y * 17.0 + uv.x * 9.0 + noise * 4.0);
        displacement += float2(wave, -abs(wave)) * 0.045;
        threshold = clamp(uv.y * 0.6 + noise * 0.4, 0.0, 1.0);
    } else { // Melt
        displacement += float2(
            sin(uv.y * 27.0 + noise * 3.0) * 0.025,
            uv.y * uv.y * 0.12
        );
        threshold = clamp(uv.y * 0.7 + noise * 0.3, 0.0, 1.0);
    }

    float motion = sin(progress * 3.14159265);
    float2 fromUV = clamp(uv - displacement * progress * motion, 0.0, 1.0);
    float2 toUV = clamp(uv + displacement * (1.0 - progress) * motion, 0.0, 1.0);
    float4 fromColor = source.sample(linearSampler, fromUV);
    float4 toColor = target.sample(linearSampler, toUV);
    float reveal = smoothstep(threshold - 0.08, threshold + 0.08, progress);
    output.write(mix(fromColor, toColor, reveal), pixel);
}
