//
//  Twirl.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 twirl(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float radiusLimit = max(min(size.x, size.y) * 0.5f, 1.0f);
    float radius = length(delta);
    if (radius >= radiusLimit) return position;
    float strength = pow(1.0f - radius / radiusLimit, 2.0f) * amount * 5.0f;
    float sine = sin(strength);
    float cosine = cos(strength);
    float2 rotated = float2(delta.x * cosine - delta.y * sine, delta.x * sine + delta.y * cosine);
    return center + rotated;
}
