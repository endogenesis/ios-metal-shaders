//
//  PolarWarp.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 polarWarp(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float radius = length(delta);
    float angle = atan2(delta.y, delta.x);
    float normalizedRadius = radius / max(min(size.x, size.y) * 0.5f, 1.0f);
    angle += sin(normalizedRadius * 10.0f) * amount * 0.7f;
    radius *= 1.0f + sin(angle * 6.0f) * amount * 0.08f;
    return center + float2(cos(angle), sin(angle)) * radius;
}
