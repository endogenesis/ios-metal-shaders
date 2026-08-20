//
//  Temperature.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 temperature(float2 position, half4 color, float amount) {
(void)position;
    float warmth = amount * 2.0f - 1.0f;
    half3 shift = half3(0.13h, 0.025h, -0.14h) * half(warmth);
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 tempered = color.rgb + shift * (0.72h + luminance * 0.28h);
    return half4(clamp(tempered, half3(0.0h), half3(1.0h)), color.a);
}
