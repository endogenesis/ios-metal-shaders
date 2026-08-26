//
//  Threshold.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 threshold(float2 position, half4 color, float amount) {
(void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half edge = half(max(0.005f, fwidth(float(luminance))));
    half value = smoothstep(half(amount) - edge, half(amount) + edge, luminance);
    return half4(half3(value), color.a);
}
