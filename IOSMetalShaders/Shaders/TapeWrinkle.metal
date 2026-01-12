//
//  TapeWrinkle.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 tapeWrinkle(float2 position, SwiftUI::Layer layer, float time, float depth) {
    float wandering = sin(position.y * 0.018f + time * 1.7f) * 2.4f;
    float wave = sin(position.y * 0.075f + wandering + time * 0.9f);
    float ridge = pow(max(wave, 0.0f), 14.0f);
    float shift = sin(position.y * 0.031f - time * 2.1f) * depth * ridge;

    half4 sampleColor = layer.sample(position + float2(shift, 0.0f));
    float channelOffset = depth * ridge * 0.15f;
    half red = layer.sample(position + float2(shift * 0.8f + channelOffset, 0.0f)).r;
    half blue = layer.sample(position + float2(shift * 0.8f - channelOffset, 0.0f)).b;
    half highlight = half(ridge * 0.22f);
    half shadow = half(pow(max(-wave, 0.0f), 18.0f) * 0.14f);

    half3 wrinkled = half3(red, sampleColor.g, blue) + highlight - shadow;
    return half4(clamp(wrinkled, half3(0.0h), half3(1.0h)), sampleColor.a);
}
