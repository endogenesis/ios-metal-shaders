//
//  LaplacianEdges.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 laplacianEdges(float2 position, SwiftUI::Layer layer, float strength) {
    half4 source = layer.sample(position);
    half3 neighbors = layer.sample(position + float2(1.0f, 0.0f)).rgb;
    neighbors += layer.sample(position + float2(-1.0f, 0.0f)).rgb;
    neighbors += layer.sample(position + float2(0.0f, 1.0f)).rgb;
    neighbors += layer.sample(position + float2(0.0f, -1.0f)).rgb;
    half3 response = abs(source.rgb * 4.0h - neighbors) * half(strength);
    half edge = max(max(response.r, response.g), response.b);
    return half4(half3(edge), source.a);
}
