//
//  Posterize.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 posterize(float2 position, half4 color, float amount) {
(void)position;
    float levels = mix(24.0f, 2.0f, amount);
    half3 posterized = floor(color.rgb * half(levels) + 0.5h) / half(levels);
    return half4(posterized, color.a);
}
