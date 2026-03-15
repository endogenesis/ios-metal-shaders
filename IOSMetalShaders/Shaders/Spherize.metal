//
//  Spherize.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 spherize(float2 position, float2 size, float strength) {
    float2 center = size * 0.5f;
    float radius = min(size.x, size.y) * 0.47f;
    float2 delta = position - center;
    float normalizedRadius = length(delta) / max(radius, 1.0f);
    if (normalizedRadius >= 1.0f) {
        return position;
    }
    float sphereRadius = asin(normalizedRadius * 0.95f) / asin(0.95f);
    float mappedRadius = mix(normalizedRadius, sphereRadius, clamp(strength, 0.0f, 1.0f));
    float2 direction = delta / max(length(delta), 1.0f);
    return center + direction * mappedRadius * radius;
}
