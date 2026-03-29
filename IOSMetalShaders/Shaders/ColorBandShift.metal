//
//  ColorBandShift.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float colorBandShiftHash(float2 value) {
    return fract(sin(dot(value, float2(97.3f, 271.1f))) * 43758.5453f);
}

[[ stitchable ]]
half4 colorBandShift(float2 position, SwiftUI::Layer layer, float time, float strength) {
    float band = floor(position.y / 16.0f);
    float frame = floor(time * 8.0f);
    float random = colorBandShiftHash(float2(band, frame));
    float active = step(0.5f, random);
    float offset = (random * 2.0f - 1.0f) * strength * active;
    half4 source = layer.sample(position);
    half red = layer.sample(position + float2(offset, 0.0f)).r;
    half green = layer.sample(position - float2(offset * 0.42f, 0.0f)).g;
    half blue = layer.sample(position + float2(offset * 0.68f, 0.0f)).b;
    half3 shifted = half3(red, green, blue);
    return half4(mix(source.rgb, shifted, half(0.82f * active)), source.a);
}
