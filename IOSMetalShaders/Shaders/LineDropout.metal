//
//  LineDropout.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 lineDropout(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float row = floor(position.y / 2.0f);
    float frame = floor(time * 12.0f);
    float random = fract(sin(row * 14.73f + frame * 5.19f) * 43758.5453f);
    float dropout = step(0.92f - amount * 0.22f, random);
    float replacementRow = floor(position.y / 18.0f) * 18.0f + 9.0f;
    half4 repeated = layer.sample(float2(position.x, replacementRow));
    half4 source = layer.sample(position);
    half darkness = half(0.08f + fract(random * 7.0f) * 0.24f);
    return mix(source, half4(repeated.rgb * darkness, source.a), half(dropout));
}
