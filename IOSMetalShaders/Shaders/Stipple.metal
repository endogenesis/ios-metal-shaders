//
//  Stipple.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float stippleHash(float2 value) {
    return fract(sin(dot(value, float2(157.7f, 269.5f))) * 43758.5453f);
}

[[ stitchable ]]
half4 stipple(float2 position, half4 color, float scale, float amount) {
    float safeScale = max(scale, 3.0f);
    float2 cell = floor(position / safeScale);
    float2 local = fract(position / safeScale);
    float2 center = float2(stippleHash(cell), stippleHash(cell + 23.4f));
    float luminance = dot(float3(color.rgb), float3(0.2126f, 0.7152f, 0.0722f));
    float radius = sqrt(max(1.0f - luminance, 0.0f)) * 0.42f;
    float dotShape = 1.0f - smoothstep(radius, radius + 0.07f, length(local - center));
    half3 paper = half3(0.95h, 0.93h, 0.86h);
    half3 ink = half3(0.06h, 0.055h, 0.07h);
    half3 stippled = mix(paper, ink, half(dotShape));
    return half4(mix(color.rgb, stippled, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
