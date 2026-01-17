//
//  SignalScramble.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float signalScrambleHash(float2 value) {
    return fract(sin(dot(value, float2(73.17f, 419.2f))) * 31849.19f);
}

[[ stitchable ]]
half4 signalScramble(float2 position, SwiftUI::Layer layer, float time, float strength) {
    float frame = floor(time * 18.0f);
    float band = floor(position.y / 7.0f);
    float noise = signalScrambleHash(float2(band, frame));
    float burst = step(0.42f, noise);
    float horizontal = (noise * 2.0f - 1.0f) * strength * burst;
    float vertical = sin(position.x * 0.12f + frame) * min(strength * 0.18f, 6.0f) * burst;

    half4 shifted = layer.sample(position + float2(horizontal, vertical));
    float channelShift = horizontal * 0.18f;
    half red = layer.sample(position + float2(horizontal - channelShift, vertical)).r;
    half blue = layer.sample(position + float2(horizontal + channelShift, vertical)).b;
    half flicker = half(0.92f + 0.08f * sin(position.y * 1.7f + time * 24.0f));

    return half4(half3(red, shifted.g, blue) * flicker, shifted.a);
}
