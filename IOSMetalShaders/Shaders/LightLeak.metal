//
//  LightLeak.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 lightLeak(float2 position, half4 color, float time, float amount) {
float2 lightCenter = float2(80.0f + sin(time * 0.7f) * 65.0f, 60.0f + cos(time * 0.53f) * 90.0f);
    float glow = exp(-length(position - lightCenter) * 0.009f);
    float streak = pow(max(0.0f, sin(position.y * 0.018f + time)), 8.0f);
    half3 leak = half3(1.0h, 0.22h, 0.04h) * half(glow) + half3(1.0h, 0.68h, 0.12h) * half(streak * 0.35f);
    half3 screened = 1.0h - (1.0h - color.rgb) * (1.0h - clamp(leak, half3(0.0h), half3(1.0h)));
    return half4(mix(color.rgb, screened, half(amount)), color.a);
}
