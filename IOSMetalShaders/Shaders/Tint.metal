//
//  Tint.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 tint(float2 position, half4 color, float amount) {
    (void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 tintColor = half3(0.08h, 0.78h, 0.72h) * (0.32h + luminance * 0.68h);
    return half4(mix(color.rgb, tintColor, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
