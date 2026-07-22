//
//  Fisheye.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 fisheye(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 halfSize = max(center, float2(1.0f));
    float2 normalized = (position - center) / halfSize;
    float radius = length(normalized);
    if (radius >= 1.0f) return position;
    float mapped = tan(radius * 0.72f) / tan(0.72f);
    float factor = mix(1.0f, mapped / max(radius, 0.0001f), amount);
    return center + normalized * factor * halfSize;
}
