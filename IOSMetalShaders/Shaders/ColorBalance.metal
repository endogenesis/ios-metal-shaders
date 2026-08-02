//
//  ColorBalance.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 colorBalance(float2 position, half4 color, float amount) {
(void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half shadowWeight = 1.0h - smoothstep(0.15h, 0.65h, luminance);
    half highlightWeight = smoothstep(0.4h, 0.92h, luminance);
    half3 balanced = color.rgb;
    balanced += half3(-0.06h, 0.01h, 0.11h) * shadowWeight * half(amount);
    balanced += half3(0.12h, 0.035h, -0.07h) * highlightWeight * half(amount);
    return half4(clamp(balanced, half3(0.0h), half3(1.0h)), color.a);
}
