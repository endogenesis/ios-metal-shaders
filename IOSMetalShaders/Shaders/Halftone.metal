//
//  Halftone.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.02.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 halftone(float2 position, half4 color, float scale, float amount) {
    float safeScale = max(scale, 2.0f);
    float2 local = fract(position / safeScale) - 0.5f;
    float luminance = dot(float3(color.rgb), float3(0.2126f, 0.7152f, 0.0722f));
    float radius = sqrt(max(1.0f - luminance, 0.0f)) * 0.47f;
    float dotShape = 1.0f - smoothstep(radius, radius + 0.055f, length(local));
    half3 ink = half3(0.035h, 0.04h, 0.055h);
    half3 paper = half3(0.96h, 0.94h, 0.88h);
    half3 printed = mix(paper, ink, half(dotShape));
    return half4(mix(color.rgb, printed, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
