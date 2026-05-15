//
//  Contrast.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.05.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 contrast(float2 position, half4 color, float amount) {
(void)position;
    float contrastValue = mix(0.35f, 2.35f, amount);
    half3 adjusted = (color.rgb - 0.5h) * half(contrastValue) + 0.5h;
    return half4(clamp(adjusted, half3(0.0h), half3(1.0h)), color.a);
}
