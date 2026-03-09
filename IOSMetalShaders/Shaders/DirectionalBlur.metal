//
//  DirectionalBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 directionalBlur(float2 position, SwiftUI::Layer layer, float radius, float angle) {
    float2 direction = float2(cos(angle), sin(angle));
    half3 sum = half3(0.0h);
    float weight = 0.0f;
    for (int index = -4; index <= 4; index++) {
        float step = float(index) / 4.0f;
        float sampleWeight = 1.0f - abs(step) * 0.35f;
        sum += layer.sample(position + direction * radius * step).rgb * half(sampleWeight);
        weight += sampleWeight;
    }
    half alpha = layer.sample(position).a;
    return half4(sum / half(weight), alpha);
}
