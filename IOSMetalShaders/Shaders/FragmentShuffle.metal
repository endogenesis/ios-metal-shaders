//
//  FragmentShuffle.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 fragmentShuffle(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 grid = float2(32.0f, 24.0f);
    float2 cell = floor(position / grid);
    float frame = floor(time * 5.0f);
    float randomX = fract(sin(dot(cell + frame, float2(71.1f, 19.7f))) * 43758.5453f);
    float randomY = fract(sin(dot(cell - frame, float2(37.9f, 83.3f))) * 24631.173f);
    float active = step(0.62f - amount * 0.18f, randomX);
    float2 offset = (float2(randomX, randomY) - 0.5f) * grid * 5.0f * amount * active;
    return layer.sample(position + offset);
}
