//
//  Emboss.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 emboss(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 1.0f + amount * 4.0f;
    half3 forward = layer.sample(position + float2(radius, radius)).rgb;
    half3 backward = layer.sample(position - float2(radius, radius)).rgb;
    half relief = dot(forward - backward, half3(0.3333h)) + 0.5h;
    half3 metal = half3(relief * 0.88h, relief * 0.94h, relief);
    return half4(metal, layer.sample(position).a);
}
