//
//  ChannelFreeze.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float channelFreezeHash(float2 value) {
    return fract(sin(dot(value, float2(91.7f, 263.3f))) * 43758.5453f);
}

[[ stitchable ]]
half4 channelFreeze(float2 position, SwiftUI::Layer layer, float time, float amount) {
    float band = floor(position.y / 18.0f);
    float frame = floor(time * 2.5f);
    float active = step(0.48f, channelFreezeHash(float2(band, frame)));
    float safeAmount = clamp(amount, 0.0f, 1.0f);
    float offset = (channelFreezeHash(float2(band, 17.0f)) * 2.0f - 1.0f)
        * 18.0f * safeAmount * active;

    half4 source = layer.sample(position);
    half4 upperSignal = layer.sample(position + float2(0.0f, offset));
    half4 lowerSignal = layer.sample(position - float2(0.0f, offset * 0.65f));
    half blendAmount = half(safeAmount * active);
    half3 frozen = half3(upperSignal.r, source.g, lowerSignal.b);

    return half4(mix(source.rgb, frozen, blendAmount), source.a);
}
