//
//  ReactionDiffusionInk.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.09.2026.
//

#include <metal_stdlib>
using namespace metal;

struct ReactionUniforms {
    uint width;
    uint height;
    uint mode;
    uint touching;
    float2 touch;
    uint step;
    uint frameIndex;
};

float reactionHash(float2 value) {
    return fract(sin(dot(value, float2(127.1, 311.7))) * 43758.5453);
}

kernel void reactionSeed(
    texture2d<float, access::write> state [[texture(0)]],
    constant ReactionUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }
    float2 uv = (float2(pixel) + 0.5) / float2(uniforms.width, uniforms.height);
    float2 cell = floor(uv * float2(8.0, 5.0));
    float2 center = (cell + 0.5) / float2(8.0, 5.0);
    float radius = 0.018 + reactionHash(cell) * 0.016;
    float spot = distance(uv, center) < radius ? 1.0 : 0.0;
    float central = distance(uv, float2(0.5)) < 0.055 ? 1.0 : 0.0;
    float v = max(spot, central);
    state.write(float4(1.0 - v * 0.5, v, 0.0, 1.0), pixel);
}

float2 reactionRead(
    texture2d<float, access::read> state,
    int2 coordinate,
    int2 maximum
) {
    return state.read(uint2(clamp(coordinate, int2(0), maximum))).rg;
}

kernel void reactionStep(
    texture2d<float, access::read> previous [[texture(0)]],
    texture2d<float, access::write> next [[texture(1)]],
    constant ReactionUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }
    int2 p = int2(pixel);
    int2 maximum = int2(uniforms.width, uniforms.height) - 1;
    float2 center = reactionRead(previous, p, maximum);
    float2 laplacian = -center;
    laplacian += 0.2 * (
        reactionRead(previous, p + int2(1, 0), maximum)
        + reactionRead(previous, p + int2(-1, 0), maximum)
        + reactionRead(previous, p + int2(0, 1), maximum)
        + reactionRead(previous, p + int2(0, -1), maximum)
    );
    laplacian += 0.05 * (
        reactionRead(previous, p + int2(1, 1), maximum)
        + reactionRead(previous, p + int2(-1, 1), maximum)
        + reactionRead(previous, p + int2(1, -1), maximum)
        + reactionRead(previous, p + int2(-1, -1), maximum)
    );

    float feed = uniforms.mode == 1u ? 0.0367 : uniforms.mode == 2u ? 0.078 : 0.055;
    float kill = uniforms.mode == 1u ? 0.0649 : uniforms.mode == 2u ? 0.061 : 0.062;
    float reaction = center.x * center.y * center.y;
    float u = center.x + 0.16 * laplacian.x - reaction + feed * (1.0 - center.x);
    float v = center.y + 0.08 * laplacian.y + reaction - (feed + kill) * center.y;

    if (uniforms.touching != 0u && uniforms.step == 0u) {
        float2 uv = (float2(pixel) + 0.5) / float2(uniforms.width, uniforms.height);
        float distanceToTouch = distance(uv, uniforms.touch);
        float injection = 1.0 - smoothstep(0.0, 0.035, distanceToTouch);
        v = max(v, 0.92 * injection);
        u = mix(u, min(u, 0.5), injection);
    }
    next.write(float4(clamp(u, 0.0, 1.0), clamp(v, 0.0, 1.0), 0.0, 1.0), pixel);
}

kernel void reactionComposite(
    texture2d<float, access::sample> source [[texture(0)]],
    texture2d<float, access::sample> state [[texture(1)]],
    texture2d<float, access::write> output [[texture(2)]],
    constant ReactionUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= source.get_width() || pixel.y >= source.get_height()) { return; }
    constexpr sampler linearSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    float2 uv = (float2(pixel) + 0.5) / float2(source.get_width(), source.get_height());
    float2 texel = 1.0 / float2(uniforms.width, uniforms.height);
    float v = state.sample(linearSampler, uv).g;
    float dx = state.sample(linearSampler, uv + float2(texel.x, 0.0)).g
        - state.sample(linearSampler, uv - float2(texel.x, 0.0)).g;
    float dy = state.sample(linearSampler, uv + float2(0.0, texel.y)).g
        - state.sample(linearSampler, uv - float2(0.0, texel.y)).g;
    float3 normal = normalize(float3(-dx * 7.0, -dy * 7.0, 1.0));
    float light = clamp(dot(normal, normalize(float3(-0.4, -0.5, 1.0))), 0.0, 1.0);
    float3 ink = mix(float3(0.02, 0.07, 0.15), float3(0.0, 0.8, 0.75), light);
    float coverage = smoothstep(0.12, 0.48, v) * 0.88;
    float4 base = source.sample(linearSampler, uv);
    output.write(float4(mix(base.rgb, ink, coverage), base.a), pixel);
}
