//
//  FrameJitter.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 31.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 frameJitter(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float frame = floor(time * 18.0f);
    float randomX = fract(sin(frame * 73.17f) * 43758.5453f) - 0.5f;
    float randomY = fract(sin(frame * 19.83f) * 12731.173f) - 0.5f;
    float2 offset = float2(randomX * 24.0f, randomY * 14.0f) * amount;
    half4 source = layer.sample(position + offset);
    float flash = step(0.97f, fract(sin(frame * 11.7f) * 951.1357f));
    source.rgb += half(flash * amount * 0.1f);
    return source;
}
