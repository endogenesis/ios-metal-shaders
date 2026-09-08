//
//  BrokenLCD.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.09.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 brokenLCD(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 grid = floor(position / float2(7.0f, 5.0f));
    float frame = floor(time * 4.0f);
    float columnNoise = fract(sin(grid.x * 71.13f) * 43758.5453f);
    float rowNoise = fract(sin(grid.y * 29.71f + frame * 0.13f) * 12731.173f);
    float frozen = step(0.91f - amount * 0.16f, columnNoise);
    float dropout = step(0.95f - amount * 0.12f, rowNoise);
    float frozenY = floor(position.y / 32.0f) * 32.0f + columnNoise * 28.0f;
    half4 source = layer.sample(mix(position, float2(position.x, frozenY), frozen));
    float bleed = (columnNoise - 0.5f) * 16.0f * amount;
    source.r = layer.sample(position + float2(bleed, 0.0f)).r;
    source.b = layer.sample(position - float2(bleed, 0.0f)).b;
    source.rgb *= half(1.0f - dropout * 0.88f);
    return source;
}
