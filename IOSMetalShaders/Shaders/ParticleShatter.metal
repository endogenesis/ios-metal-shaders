//
//  ParticleShatter.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.09.2026.
//

#include <metal_stdlib>
using namespace metal;

struct ParticleUniforms {
    uint width;
    uint height;
    uint columns;
    uint tileSize;
    float progress;
    float intensity;
    uint seed;
    uint padding;
};

struct ParticleVertexOut {
    float4 position [[position]];
    float2 uv;
    float2 local;
    float progress;
};

float particleRandom(uint value) {
    value ^= value >> 16;
    value *= 0x7feb352du;
    value ^= value >> 15;
    value *= 0x846ca68bu;
    value ^= value >> 16;
    return float(value) / 4294967295.0;
}

vertex ParticleVertexOut particleShatterVertex(
    uint vertexID [[vertex_id]],
    uint instanceID [[instance_id]],
    constant ParticleUniforms &uniforms [[buffer(0)]]
) {
    const float2 corners[6] = {
        float2(0.0, 0.0), float2(1.0, 0.0), float2(0.0, 1.0),
        float2(1.0, 0.0), float2(1.0, 1.0), float2(0.0, 1.0)
    };
    float2 local = corners[vertexID];
    uint2 tile = uint2(instanceID % uniforms.columns, instanceID / uniforms.columns);
    float2 origin = float2(tile * uniforms.tileSize);
    float2 extent = min(float2(uniforms.tileSize),
        float2(uniforms.width, uniforms.height) - origin);
    float2 center = origin + extent * 0.5;
    float2 offset = (local - 0.5) * extent;
    float progress = clamp(uniforms.progress, 0.0, 1.0);
    float randomAngle = particleRandom(instanceID ^ uniforms.seed) * 6.2831853;
    float speed = 0.35 + particleRandom(instanceID * 17u + uniforms.seed) * 0.85;
    float spin = (particleRandom(instanceID * 43u + uniforms.seed) - 0.5) * 6.0;
    float angle = spin * progress;
    float2 rotated = float2(
        offset.x * cos(angle) - offset.y * sin(angle),
        offset.x * sin(angle) + offset.y * cos(angle)
    );
    float2 direction = float2(cos(randomAngle), sin(randomAngle));
    float curl = sin(progress * 8.0 + randomAngle * 3.0) * progress * 18.0;
    float2 trajectory = direction * speed * progress * 135.0
        + float2(-direction.y, direction.x) * curl
        + float2(0.0, progress * progress * 75.0);
    float2 position = center + rotated + trajectory * uniforms.intensity;
    float2 clip = float2(
        position.x / float(uniforms.width) * 2.0 - 1.0,
        1.0 - position.y / float(uniforms.height) * 2.0
    );
    ParticleVertexOut output;
    output.position = float4(clip, 0.0, 1.0);
    output.uv = (origin + local * extent) / float2(uniforms.width, uniforms.height);
    output.local = local;
    output.progress = progress;
    return output;
}

fragment float4 particleShatterFragment(
    ParticleVertexOut input [[stage_in]],
    texture2d<float, access::sample> source [[texture(0)]],
    constant ParticleUniforms &uniforms [[buffer(0)]]
) {
    constexpr sampler nearestSampler(coord::normalized, address::clamp_to_edge, filter::nearest);
    float4 color = source.sample(nearestSampler, input.uv);
    float edge = 1.0 - smoothstep(0.0, 0.22,
        min(min(input.local.x, 1.0 - input.local.x),
            min(input.local.y, 1.0 - input.local.y)));
    float fade = 1.0 - input.progress * 0.22;
    float glow = edge * input.progress * uniforms.intensity * 0.18;
    return float4((color.rgb * fade) + float3(glow * 0.4, glow * 0.7, glow),
        color.a * fade);
}
