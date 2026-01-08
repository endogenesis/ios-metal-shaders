//
//  PencilSketch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float pencilLuminance(half3 color) {
    return dot(float3(color), float3(0.2126f, 0.7152f, 0.0722f));
}

[[ stitchable ]]
half4 pencilSketch(float2 position, SwiftUI::Layer layer, float strength) {
    float left = pencilLuminance(layer.sample(position + float2(-2.0f, 0.0f)).rgb);
    float right = pencilLuminance(layer.sample(position + float2(2.0f, 0.0f)).rgb);
    float top = pencilLuminance(layer.sample(position + float2(0.0f, -2.0f)).rgb);
    float bottom = pencilLuminance(layer.sample(position + float2(0.0f, 2.0f)).rgb);
    float diagonalA = pencilLuminance(layer.sample(position + float2(-1.0f, -1.0f)).rgb);
    float diagonalB = pencilLuminance(layer.sample(position + float2(1.0f, 1.0f)).rgb);
    float edge = length(float2(right - left, bottom - top));
    edge += abs(diagonalB - diagonalA) * 0.35f;

    half4 source = layer.sample(position);
    float sourceLuminance = pencilLuminance(source.rgb);
    float paper = 0.96f - edge * clamp(strength, 0.5f, 2.5f) * 1.8f;
    paper -= (1.0f - sourceLuminance) * 0.08f;

    return half4(half3(clamp(paper, 0.04f, 1.0f)), source.a);
}
