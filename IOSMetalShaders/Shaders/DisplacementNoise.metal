//
//  DisplacementNoise.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 displacementNoise(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 cell = floor(position / 22.0f);
    float phase = floor(time * 10.0f);
    float noise = fract(sin(dot(cell + phase, float2(127.1f, 311.7f))) * 43758.5453f);
    float angle = noise * 6.2831853f + time;
    float2 offset = float2(cos(angle), sin(angle)) * (noise - 0.25f) * 28.0f * amount;
    return layer.sample(position + offset);
}
