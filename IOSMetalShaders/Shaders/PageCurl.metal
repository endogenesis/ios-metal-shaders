//
//  PageCurl.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.02.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 pageCurl(float2 position, float2 size, float progress, float depth) {
    float fold = size.x * (1.0f - clamp(progress, 0.0f, 1.0f));
    float distancePastFold = max(position.x - fold, 0.0f);
    float safeDepth = max(depth, 1.0f);
    float phase = min(distancePastFold / safeDepth, 1.0f) * 3.1415927f;
    float curl = sin(phase) * safeDepth * 0.72f;
    float vertical = (1.0f - cos(phase)) * safeDepth * 0.28f;
    float side = position.y < size.y * 0.5f ? -1.0f : 1.0f;
    return float2(position.x - curl, position.y + vertical * side);
}
