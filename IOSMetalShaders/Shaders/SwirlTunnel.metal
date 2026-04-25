//
//  SwirlTunnel.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 swirlTunnel(float2 position, float2 size, float time, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float radius = length(delta) / max(min(size.x, size.y) * 0.5f, 1.0f);
    float angle = atan2(delta.y, delta.x);
    angle += (1.0f - clamp(radius, 0.0f, 1.0f)) * amount * 4.2f + sin(radius * 18.0f - time * 2.0f) * amount * 0.12f;
    float scale = 1.0f + sin(time + radius * 12.0f) * amount * 0.04f;
    return center + float2(cos(angle), sin(angle)) * length(delta) * scale;
}
