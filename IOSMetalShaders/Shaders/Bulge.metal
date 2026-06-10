//
//  Bulge.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 bulge(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float maxRadius = max(min(size.x, size.y) * 0.48f, 1.0f);
    float radius = length(delta) / maxRadius;
    if (radius >= 1.0f) return position;
    float factor = mix(1.0f, 0.35f + 0.65f * radius * radius, amount);
    return center + delta * factor;
}
