//
//  Kaleidoscope.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 kaleidoscope(float2 position, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 delta = position - center;
    float radius = length(delta);
    float angle = atan2(delta.y, delta.x);
    float segments = floor(mix(3.0f, 10.0f, amount));
    float wedge = 6.2831853f / segments;
    angle = abs(fmod(angle + wedge * 0.5f, wedge) - wedge * 0.5f);
    return center + float2(cos(angle), sin(angle)) * radius;
}
