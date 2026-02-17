//
//  Watercolor.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float watercolorHash(float2 value) {
    return fract(sin(dot(value, float2(63.31f, 241.17f))) * 43758.5453f);
}

[[ stitchable ]]
half4 watercolor(float2 position, SwiftUI::Layer layer, float radius, float amount) {
    half4 source = layer.sample(position);
    half3 sum = source.rgb;
    for (int index = 0; index < 6; index++) {
        float angle = float(index) * 1.0471976f + watercolorHash(position) * 0.4f;
        float2 offset = float2(cos(angle), sin(angle)) * radius;
        sum += layer.sample(position + offset).rgb;
    }
    half3 washed = sum / 7.0h;
    washed = floor(washed * 10.0h + 0.5h) / 10.0h;
    half paper = half((watercolorHash(floor(position * 0.7f)) - 0.5f) * 0.035f);
    washed = clamp(washed + paper, half3(0.0h), half3(1.0h));
    return half4(mix(source.rgb, washed, half(clamp(amount, 0.0f, 1.0f))), source.a);
}
