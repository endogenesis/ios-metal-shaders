//
//  Blueprint.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 blueprint(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 1.0f + amount * 2.5f;
    half3 left = layer.sample(position - float2(radius, 0.0f)).rgb;
    half3 right = layer.sample(position + float2(radius, 0.0f)).rgb;
    half3 up = layer.sample(position - float2(0.0f, radius)).rgb;
    half3 down = layer.sample(position + float2(0.0f, radius)).rgb;
    half edge = length(right - left) + length(down - up);
    half luminance = dot(layer.sample(position).rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 paper = half3(0.025h, 0.13h, 0.28h) + luminance * half3(0.01h, 0.05h, 0.08h);
    half3 ink = mix(paper, half3(0.68h, 0.9h, 1.0h), smoothstep(0.08h, 0.34h, edge));
    return half4(ink, layer.sample(position).a);
}
