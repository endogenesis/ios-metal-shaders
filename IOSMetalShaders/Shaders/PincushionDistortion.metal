//
//  PincushionDistortion.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.05.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 pincushionDistortion(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 halfSize = max(center, float2(1.0f));
    float2 normalized = (position - center) / halfSize;
    float radiusSquared = dot(normalized, normalized);
    float scale = max(0.45f, 1.0f - radiusSquared * amount * 0.34f);
    return center + normalized * scale * halfSize;
}
