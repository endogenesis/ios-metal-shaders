//
//  PerspectiveTilt.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.02.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 perspectiveTilt(float2 position, float2 size, float amount) {
    float normalizedY = position.y / max(size.y, 1.0f) - 0.5f;
    float scale = max(0.55f, 1.0f + normalizedY * amount * 1.4f);
    float centerX = size.x * 0.5f;
    float sourceX = centerX + (position.x - centerX) / scale;
    return float2(sourceX, position.y);
}
