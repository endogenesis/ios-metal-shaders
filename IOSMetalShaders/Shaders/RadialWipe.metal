//
//  RadialWipe.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 radialWipe(float2 position, half4 color, float2 size, float amount) {
float2 center = size * 0.5f;
    float angle = atan2(position.y - center.y, position.x - center.x);
    float normalizedAngle = fract(angle / 6.2831853f + 1.25f);
    float edge = max(0.002f, 8.0f / max(size.x + size.y, 1.0f));
    float mask = 1.0f - smoothstep(amount - edge, amount + edge, normalizedAngle);
    half rim = half(1.0f - smoothstep(0.0f, edge * 3.0f, abs(normalizedAngle - amount)));
    return half4(color.rgb + rim * half3(0.18h, 0.12h, 0.04h), color.a * half(mask));
}
