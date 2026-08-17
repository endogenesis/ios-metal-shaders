//
//  Saturation.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 saturation(float2 position, half4 color, float amount) {
(void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    float saturationValue = mix(0.0f, 2.0f, amount);
    half3 saturated = mix(half3(luminance), color.rgb, half(saturationValue));
    return half4(clamp(saturated, half3(0.0h), half3(1.0h)), color.a);
}
