//
//  DoubleVision.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 doubleVision(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float offset = 2.0f + amount * 20.0f;
    half4 left = layer.sample(position - float2(offset, offset * 0.16f));
    half4 right = layer.sample(position + float2(offset, -offset * 0.16f));
    half3 overlap = left.rgb * 0.5h + right.rgb * 0.5h;
    overlap += half3(left.r, right.g, right.b) * half(amount * 0.12f);
    return half4(clamp(overlap, half3(0.0h), half3(1.0h)), max(left.a, right.a));
}
