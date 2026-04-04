//
//  Exposure.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 exposure(float2 position, half4 color, float amount) {
(void)position;
    float stops = (amount * 2.0f - 1.0f) * 2.5f;
    half3 exposed = color.rgb * half(exp2(stops));
    return half4(clamp(exposed, half3(0.0h), half3(1.0h)), color.a);
}
