//
//  FrostedNoise.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float frostedHash(float2 value) {
    return fract(sin(dot(value, float2(41.23f, 289.17f))) * 45758.5453f);
}

[[ stitchable ]]
half4 frostedNoise(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float radius,
    float amount
) {
    float frame = floor(time * 15.0f);
    float2 cell = floor(position * 0.8f);
    float angle = frostedHash(cell + frame) * 6.2831853f;
    float distance = sqrt(frostedHash(cell.yx + frame * 1.73f)) * max(radius, 0.0f);
    float2 offset = float2(cos(angle), sin(angle)) * distance;

    half4 source = layer.sample(position);
    half4 scattered = layer.sample(position + offset);
    half safeAmount = half(clamp(amount, 0.0f, 1.0f));

    return mix(source, scattered, safeAmount);
}
