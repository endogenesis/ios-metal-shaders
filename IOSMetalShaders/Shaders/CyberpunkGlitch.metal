//
//  CyberpunkGlitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 cyberpunkGlitch(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float band = floor(position.y / 11.0f);
    float pulse = step(0.62f, fract(sin(band * 91.7f + floor(time * 12.0f)) * 43758.5f));
    float shift = sin(band + time * 4.0f) * 24.0f * amount * pulse;
    half4 source = layer.sample(position);
    half3 neon = half3(layer.sample(position + float2(shift, 0.0f)).r, source.g, layer.sample(position - float2(shift, 0.0f)).b);
    neon += half3(0.06h, 0.0h, 0.08h) * half(pulse * amount);
    return half4(mix(source.rgb, neon, half(0.85f * amount)), source.a);
}
