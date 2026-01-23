//
//  HexBokeh.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 hexBokeh(float2 position, SwiftUI::Layer layer, float radius, float amount) {
    half4 source = layer.sample(position);
    half3 sum = source.rgb;

    for (int index = 0; index < 6; index++) {
        float angle = float(index) * 1.0471976f;
        float2 offset = float2(cos(angle), sin(angle)) * radius;
        sum += layer.sample(position + offset).rgb;
    }

    half3 blurred = sum / 7.0h;
    half highlight = half(max(max(float(blurred.r), float(blurred.g)), float(blurred.b)));
    blurred += half3(highlight * 0.08h);
    return half4(mix(source.rgb, blurred, half(clamp(amount, 0.0f, 1.0f))), source.a);
}
