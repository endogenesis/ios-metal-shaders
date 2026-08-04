//
//  ToonShade.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 toonShade(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
half4 source = layer.sample(position);
    float radius = 1.0f + amount * 2.0f;
    half3 right = layer.sample(position + float2(radius, 0.0f)).rgb;
    half3 down = layer.sample(position + float2(0.0f, radius)).rgb;
    half edge = length(source.rgb - right) + length(source.rgb - down);
    float levels = mix(9.0f, 3.0f, amount);
    half3 bands = floor(source.rgb * half(levels)) / half(max(levels - 1.0f, 1.0f));
    half ink = 1.0h - smoothstep(0.12h, 0.38h, edge) * half(amount);
    return half4(clamp(bands * ink, half3(0.0h), half3(1.0h)), source.a);
}
