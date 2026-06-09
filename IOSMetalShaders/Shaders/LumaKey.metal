//
//  LumaKey.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 lumaKey(float2 position, half4 color, float amount) {
(void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half threshold = half(amount * 0.82f);
    half mask = smoothstep(threshold - 0.08h, threshold + 0.08h, luminance);
    return half4(color.rgb, color.a * mask);
}
