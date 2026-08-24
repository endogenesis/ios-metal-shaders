//
//  Outline.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 outline(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 1.0f + amount * 3.5f;
    half3 left = layer.sample(position - float2(radius, 0.0f)).rgb;
    half3 right = layer.sample(position + float2(radius, 0.0f)).rgb;
    half3 up = layer.sample(position - float2(0.0f, radius)).rgb;
    half3 down = layer.sample(position + float2(0.0f, radius)).rgb;
    half edge = length(right - left) + length(down - up);
    half line = 1.0h - smoothstep(0.08h, 0.34h, edge);
    return half4(half3(line), layer.sample(position).a);
}
