//
//  ChannelDrift.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 channelDrift(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float phase = position.y * 0.025f + time * 1.8f;
    float redOffset = sin(phase) * 18.0f * amount;
    float greenOffset = sin(phase + 2.094f) * 10.0f * amount;
    float blueOffset = sin(phase + 4.188f) * 18.0f * amount;
    half4 source = layer.sample(position);
    return half4(layer.sample(position + float2(redOffset, 0.0f)).r,
                 layer.sample(position + float2(greenOffset, 0.0f)).g,
                 layer.sample(position + float2(blueOffset, 0.0f)).b,
                 source.a);
}
