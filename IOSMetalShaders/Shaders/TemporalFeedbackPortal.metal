//
//  TemporalFeedbackPortal.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.09.2026.
//

#include <metal_stdlib>
using namespace metal;

struct FeedbackUniforms {
    uint width;
    uint height;
    uint frameIndex;
    uint padding;
    float2 center;
    float intensity;
    float decay;
};

kernel void feedbackSeed(
    texture2d<float, access::read> source [[texture(0)]],
    texture2d<float, access::write> history [[texture(1)]],
    constant FeedbackUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }
    history.write(source.read(pixel), pixel);
}

kernel void temporalFeedback(
    texture2d<float, access::read> source [[texture(0)]],
    texture2d<float, access::sample> previous [[texture(1)]],
    texture2d<float, access::write> next [[texture(2)]],
    constant FeedbackUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }
    constexpr sampler linearSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    float2 uv = (float2(pixel) + 0.5) / float2(uniforms.width, uniforms.height);
    float2 relative = uv - uniforms.center;
    float angle = 0.012 + uniforms.intensity * 0.018;
    float2 rotated = float2(
        relative.x * cos(angle) - relative.y * sin(angle),
        relative.x * sin(angle) + relative.y * cos(angle)
    );
    float curl = sin(uv.x * 22.0 + float(uniforms.frameIndex) * 0.045)
        * cos(uv.y * 18.0 - float(uniforms.frameIndex) * 0.032);
    float2 historyUV = uniforms.center + rotated * (1.018 + uniforms.intensity * 0.014)
        + float2(curl, -curl) * 0.0018;
    float4 oldColor = previous.sample(linearSampler, historyUV);
    float4 newColor = source.read(pixel);
    float3 combined = newColor.rgb * 0.30
        + oldColor.rgb * uniforms.decay * 0.68;
    next.write(float4(clamp(combined, 0.0, 4.0), newColor.a), pixel);
}

kernel void feedbackComposite(
    texture2d<float, access::sample> history [[texture(0)]],
    texture2d<float, access::write> output [[texture(1)]],
    constant FeedbackUniforms &uniforms [[buffer(0)]],
    uint2 pixel [[thread_position_in_grid]]
) {
    if (pixel.x >= uniforms.width || pixel.y >= uniforms.height) { return; }
    constexpr sampler linearSampler(coord::normalized, address::clamp_to_edge, filter::linear);
    float2 size = float2(uniforms.width, uniforms.height);
    float2 uv = (float2(pixel) + 0.5) / size;
    float4 color = history.sample(linearSampler, uv);
    float3 glow = float3(0.0);
    float2 dx = float2(3.0 / size.x, 0.0);
    float2 dy = float2(0.0, 3.0 / size.y);
    for (uint i = 0; i < 4; i++) {
        float2 offset = i == 0u ? dx : i == 1u ? -dx : i == 2u ? dy : -dy;
        float3 neighbor = history.sample(linearSampler, uv + offset).rgb;
        glow += max(neighbor - 0.6, 0.0) * 0.25;
    }
    float3 mapped = 1.0 - exp(-(color.rgb + glow * 0.24));
    output.write(float4(mapped, color.a), pixel);
}
