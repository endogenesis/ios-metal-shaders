//
//  ThermalVision.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 thermalVision(float2 position, half4 color, float amount) {
(void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 cold = mix(half3(0.02h, 0.0h, 0.2h), half3(0.05h, 0.45h, 1.0h), smoothstep(0.0h, 0.35h, luminance));
    half3 warm = mix(half3(0.95h, 0.08h, 0.02h), half3(1.0h, 0.96h, 0.32h), smoothstep(0.65h, 1.0h, luminance));
    half3 thermal = mix(cold, warm, smoothstep(0.3h, 0.72h, luminance));
    return half4(mix(color.rgb, thermal, half(amount)), color.a);
}
