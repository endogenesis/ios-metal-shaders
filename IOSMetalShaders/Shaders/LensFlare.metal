//
//  LensFlare.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 lensFlare(float2 position, half4 color, float2 size, float time, float intensity) {
    float2 light = size * float2(0.24f + sin(time * 0.35f) * 0.06f, 0.25f + cos(time * 0.27f) * 0.05f);
    float2 center = size * 0.5f;
    float diagonal = max(length(size), 1.0f);
    float glowDistance = length(position - light) / diagonal;
    float glow = exp(-glowDistance * 18.0f);
    float2 axis = center - light;
    float ghostA = exp(-length(position - (light + axis * 0.78f)) / diagonal * 42.0f);
    float ghostB = exp(-length(position - (light + axis * 1.34f)) / diagonal * 55.0f);
    float haloDistance = abs(length(position - light) / diagonal - 0.16f);
    float halo = 1.0f - smoothstep(0.0f, 0.018f, haloDistance);
    float flare = (glow + ghostA * 0.5f + ghostB * 0.32f + halo * 0.24f) * clamp(intensity, 0.0f, 1.0f);
    half3 flareColor = half3(1.0h, 0.68h, 0.32h) * half(glow);
    flareColor += half3(0.3h, 0.62h, 1.0h) * half(ghostA * 0.5f + ghostB * 0.32f);
    flareColor += half3(1.0h, 0.35h, 0.16h) * half(halo * 0.24f);
    return half4(clamp(color.rgb + flareColor * half(flare), half3(0.0h), half3(1.0h)), color.a);
}
