//
//  RainGlass.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 rainGlass(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 grid = float2(24.0f, 36.0f);
    float2 moving = position + float2(0.0f, time * 28.0f);
    float2 cell = floor(moving / grid);
    float random = fract(sin(dot(cell, float2(91.7f, 27.3f))) * 43758.5453f);
    float2 local = fract(moving / grid) - float2(0.5f, random * 0.45f);
    local.x *= 1.35f;
    float drop = smoothstep(0.48f, 0.12f, length(local));
    float2 normal = normalize(local + float2(0.001f)) * drop;
    half4 refracted = layer.sample(position + normal * 12.0f * amount);
    refracted.rgb += half(drop * amount * 0.1f);
    return refracted;
}
