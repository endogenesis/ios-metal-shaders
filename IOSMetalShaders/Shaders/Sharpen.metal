//
//  Sharpen.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 sharpen(float2 position, SwiftUI::Layer layer, float radius, float amount) {
    half4 source = layer.sample(position);
    half3 neighbors = layer.sample(position + float2(radius, 0.0f)).rgb;
    neighbors += layer.sample(position - float2(radius, 0.0f)).rgb;
    neighbors += layer.sample(position + float2(0.0f, radius)).rgb;
    neighbors += layer.sample(position - float2(0.0f, radius)).rgb;
    half safeAmount = half(clamp(amount, 0.0f, 1.5f));
    half3 result = source.rgb * (1.0h + 4.0h * safeAmount) - neighbors * safeAmount;
    return half4(clamp(result, half3(0.0h), half3(1.0h)), source.a);
}
