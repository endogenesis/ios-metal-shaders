//
//  BarrelDistortion.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 barrelDistortion(float2 position, float2 size, float strength) {
    float2 center = size * 0.5f;
    float2 halfSize = max(center, float2(1.0f));
    float2 normalized = (position - center) / halfSize;
    float radiusSquared = dot(normalized, normalized);
    float2 distorted = normalized * (1.0f + radiusSquared * clamp(strength, 0.0f, 0.3f));
    return center + distorted * halfSize;
}
