//
//  CRTCurvature.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 06.09.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 crtCurvature(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 halfSize = max(center, float2(1.0f));
    float2 normalized = (position - center) / halfSize;
    float2 curved = normalized;
    curved.x *= 1.0f + normalized.y * normalized.y * amount * 0.16f;
    curved.y *= 1.0f + normalized.x * normalized.x * amount * 0.2f;
    float vignetteScale = mix(1.0f, 0.94f, amount);
    return center + curved * halfSize * vignetteScale;
}
