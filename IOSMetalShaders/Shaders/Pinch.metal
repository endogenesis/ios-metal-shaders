//
//  Pinch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 pinch(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float radius = length(delta) / max(min(size.x, size.y) * 0.5f, 1.0f);
    if (radius >= 1.0f) return position;
    float exponent = 1.0f + amount * 1.8f;
    float mapped = pow(max(radius, 0.0001f), exponent);
    return center + delta * (mapped / max(radius, 0.0001f));
}
