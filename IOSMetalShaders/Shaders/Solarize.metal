//
//  Solarize.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 solarize(float2 position, half4 color, float threshold, float amount) {
    (void)position;
    half3 mask = step(half3(half(threshold)), color.rgb);
    half3 solarized = mix(color.rgb, 1.0h - color.rgb, mask);
    return half4(mix(color.rgb, solarized, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
