//
//  LensRefraction.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 lensRefraction(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float radius = max(min(size.x, size.y) * 0.44f, 1.0f);
    float2 delta = position - center;
    float normalizedRadius = length(delta) / radius;
    if (normalizedRadius >= 1.0f) return position;
    float depth = sqrt(max(0.0f, 1.0f - normalizedRadius * normalizedRadius));
    float refraction = mix(1.0f, 0.62f + depth * 0.2f, amount);
    return center + delta * refraction;
}
