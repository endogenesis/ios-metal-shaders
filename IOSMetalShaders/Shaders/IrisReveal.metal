//
//  IrisReveal.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 irisReveal(float2 position, half4 color, float2 size, float progress, float softness) {
    float2 center = size * 0.5f;
    float maximumRadius = length(center);
    float radius = clamp(progress, 0.0f, 1.0f) * maximumRadius * 1.04f;
    float mask = 1.0f - smoothstep(radius, radius + max(softness, 1.0f), length(position - center));
    return half4(color.rgb, color.a * half(mask));
}
