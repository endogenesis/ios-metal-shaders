//
//  ColorInvert.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 colorInvert(float2 position, half4 color, float amount) {
    (void)position;
    half3 inverted = 1.0h - color.rgb;
    return half4(mix(color.rgb, inverted, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
