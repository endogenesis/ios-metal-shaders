//
//  Vignette.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.02.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 vignette(float2 position, half4 color, float2 size, float strength) {
    float2 uv = position / max(size, float2(1.0f));
    float2 centered = uv * 2.0f - 1.0f;
    centered.x *= size.x / max(size.y, 1.0f);
    float edge = smoothstep(0.35f, 1.25f, length(centered));
    half factor = half(1.0f - edge * clamp(strength, 0.0f, 1.0f));
    return half4(color.rgb * factor, color.a);
}
