//
//  Vibrance.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 vibrance(float2 position, half4 color, float amount) {
(void)position;
    half maximum = max(color.r, max(color.g, color.b));
    half minimum = min(color.r, min(color.g, color.b));
    half saturation = maximum - minimum;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half boost = half(amount) * (1.0h - saturation) * 1.45h;
    half3 vibrant = mix(half3(luminance), color.rgb, 1.0h + boost);
    return half4(clamp(vibrant, half3(0.0h), half3(1.0h)), color.a);
}
