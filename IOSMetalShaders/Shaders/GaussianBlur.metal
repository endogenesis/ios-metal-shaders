//
//  GaussianBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 gaussianBlur(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 1.0f + amount * 9.0f;
    half4 sum = layer.sample(position) * 0.227027h;
    sum += layer.sample(position + float2(radius * 1.384615f, 0.0f)) * 0.158108h;
    sum += layer.sample(position - float2(radius * 1.384615f, 0.0f)) * 0.158108h;
    sum += layer.sample(position + float2(0.0f, radius * 1.384615f)) * 0.158108h;
    sum += layer.sample(position - float2(0.0f, radius * 1.384615f)) * 0.158108h;
    sum += layer.sample(position + float2(radius * 3.230769f, 0.0f)) * 0.074311h;
    sum += layer.sample(position - float2(radius * 3.230769f, 0.0f)) * 0.074311h;
    return sum;
}
