//
//  RGBSplit.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 rgbSplit(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float offset = 2.0f + amount * 22.0f;
    half4 source = layer.sample(position);
    half red = layer.sample(position + float2(offset, 0.0f)).r;
    half green = layer.sample(position + float2(0.0f, offset * 0.3f)).g;
    half blue = layer.sample(position - float2(offset, 0.0f)).b;
    return half4(red, green, blue, source.a);
}
