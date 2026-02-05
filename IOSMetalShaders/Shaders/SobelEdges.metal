//
//  SobelEdges.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float sobelLuminance(half3 color) {
    return dot(float3(color), float3(0.2126f, 0.7152f, 0.0722f));
}

[[ stitchable ]]
half4 sobelEdges(float2 position, SwiftUI::Layer layer, float strength) {
    float topLeft = sobelLuminance(layer.sample(position + float2(-1.0f, -1.0f)).rgb);
    float top = sobelLuminance(layer.sample(position + float2(0.0f, -1.0f)).rgb);
    float topRight = sobelLuminance(layer.sample(position + float2(1.0f, -1.0f)).rgb);
    float left = sobelLuminance(layer.sample(position + float2(-1.0f, 0.0f)).rgb);
    float right = sobelLuminance(layer.sample(position + float2(1.0f, 0.0f)).rgb);
    float bottomLeft = sobelLuminance(layer.sample(position + float2(-1.0f, 1.0f)).rgb);
    float bottom = sobelLuminance(layer.sample(position + float2(0.0f, 1.0f)).rgb);
    float bottomRight = sobelLuminance(layer.sample(position + float2(1.0f, 1.0f)).rgb);
    float gradientX = -topLeft - 2.0f * left - bottomLeft + topRight + 2.0f * right + bottomRight;
    float gradientY = -topLeft - 2.0f * top - topRight + bottomLeft + 2.0f * bottom + bottomRight;
    float edge = clamp(length(float2(gradientX, gradientY)) * strength, 0.0f, 1.0f);
    half alpha = layer.sample(position).a;
    return half4(half3(edge), alpha);
}
