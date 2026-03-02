//
//  EchoFrames.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 echoFrames(float2 position, SwiftUI::Layer layer, float time, float distance) {
    half4 source = layer.sample(position);
    half3 sum = source.rgb * 0.48h;
    float weight = 0.48f;
    for (int index = 1; index <= 4; index++) {
        float phase = time * 0.9f - float(index) * 0.72f;
        float scale = float(index) / 4.0f;
        float2 offset = float2(cos(phase), sin(phase)) * distance * scale;
        half3 echo = layer.sample(position + offset).rgb;
        half3 tint = half3(half(1.0f - scale * 0.14f), half(1.0f - scale * 0.05f), 1.0h);
        float echoWeight = 0.22f - scale * 0.025f;
        sum += echo * tint * half(echoWeight);
        weight += echoWeight;
    }
    return half4(sum / half(weight), source.a);
}
