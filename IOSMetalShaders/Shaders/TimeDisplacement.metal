//
//  TimeDisplacement.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 timeDisplacement(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float wave = sin(position.y * 0.052f + time * 3.1f);
    wave += 0.45f * sin(position.y * 0.017f - time * 2.3f);
    float2 offset = float2(wave * 18.0f * amount, sin(position.x * 0.028f + time) * 3.0f * amount);
    half4 displaced = layer.sample(position + offset);
    half echo = layer.sample(position - offset * 0.35f).b;
    displaced.b = mix(displaced.b, echo, half(0.35f * amount));
    return displaced;
}
