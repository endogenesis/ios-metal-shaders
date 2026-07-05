//
//  Levels.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 levels(float2 position, half4 color, float amount) {
(void)position;
    half3 normalized = clamp((color.rgb - 0.07h) / 0.86h, half3(0.0h), half3(1.0h));
    half3 corrected = pow(normalized, half3(0.82h));
    return half4(mix(color.rgb, corrected, half(amount)), color.a);
}
