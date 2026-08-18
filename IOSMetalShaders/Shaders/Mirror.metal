//
//  Mirror.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 mirror(float2 position, float2 size, float amount) {
float center = size.x * 0.5f;
    float mirroredX = center - abs(position.x - center);
    float blendWidth = max(1.0f, size.x * 0.08f);
    float edgeBlend = smoothstep(0.0f, blendWidth, abs(position.x - center));
    float targetX = mix(position.x, mirroredX, amount * edgeBlend);
    return float2(targetX, position.y);
}
