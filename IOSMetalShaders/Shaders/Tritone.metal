//
//  Tritone.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 tritone(float2 position, half4 color, float amount) {
    (void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 shadows = half3(0.035h, 0.09h, 0.19h);
    half3 midtones = half3(0.72h, 0.24h, 0.34h);
    half3 highlights = half3(1.0h, 0.82h, 0.42h);
    half lowBlend = smoothstep(0.0h, 0.5h, luminance);
    half highBlend = smoothstep(0.5h, 1.0h, luminance);
    half3 lower = mix(shadows, midtones, lowBlend);
    half3 mapped = mix(lower, highlights, highBlend);
    return half4(mix(color.rgb, mapped, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
