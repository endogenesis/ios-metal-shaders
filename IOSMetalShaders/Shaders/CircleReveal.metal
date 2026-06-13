//
//  CircleReveal.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 circleReveal(float2 position, half4 color, float2 size, float amount) {
float2 center = size * 0.5f;
    float distanceFromCenter = length(position - center);
    float radius = length(size) * 0.62f * amount;
    float mask = 1.0f - smoothstep(radius - 10.0f, radius + 2.0f, distanceFromCenter);
    half rim = half(1.0f - smoothstep(0.0f, 9.0f, abs(distanceFromCenter - radius)));
    half3 rgb = color.rgb + rim * half3(0.18h, 0.12h, 0.04h);
    return half4(rgb, color.a * half(mask));
}
