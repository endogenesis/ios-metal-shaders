//
//  ColorCurves.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 colorCurves(float2 position, half4 color, float amount) {
    (void)position;
    half3 curved = color.rgb * color.rgb * (3.0h - 2.0h * color.rgb);
    half3 warmCurve = half3(curved.r * 1.03h, curved.g, curved.b * 0.97h);
    return half4(mix(color.rgb, clamp(warmCurve, half3(0.0h), half3(1.0h)), half(clamp(amount, 0.0f, 1.0f))), color.a);
}
