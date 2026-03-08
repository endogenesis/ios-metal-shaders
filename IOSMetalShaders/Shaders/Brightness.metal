//
//  Brightness.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 brightness(float2 position, half4 color, float amount) {
    (void)position;
    half3 result = clamp(color.rgb + half3(half(amount)), half3(0.0h), half3(1.0h));
    return half4(result, color.a);
}
