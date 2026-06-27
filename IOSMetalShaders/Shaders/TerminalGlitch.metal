//
//  TerminalGlitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.06.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 terminalGlitch(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float row = floor(position.y / 7.0f);
    float random = fract(sin(row * 82.13f + floor(time * 12.0f)) * 43758.5f);
    float shift = (random - 0.5f) * 38.0f * amount * step(0.72f, random);
    half4 source = layer.sample(position + float2(shift, 0.0f));
    half luminance = dot(source.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half scan = half(0.82f + 0.18f * sin(position.y * 3.14159f));
    half3 terminal = half3(0.03h, luminance * 1.18h, 0.18h + luminance * 0.2h) * scan;
    return half4(mix(source.rgb, terminal, half(amount)), source.a);
}
