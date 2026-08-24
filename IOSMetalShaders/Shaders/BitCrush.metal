//
//  BitCrush.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 bitCrush(float2 position, half4 color, float amount) {
float levels = exp2(mix(8.0f, 1.0f, amount));
    half3 crushed = floor(color.rgb * half(levels)) / half(max(levels - 1.0f, 1.0f));
    float dither = fract(sin(dot(position, float2(12.9898f, 78.233f))) * 43758.5453f) - 0.5f;
    crushed += half(dither * amount / max(levels, 1.0f));
    return half4(clamp(crushed, half3(0.0h), half3(1.0h)), color.a);
}
