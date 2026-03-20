//
//  MotionBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 motionBlur(float2 position, SwiftUI::Layer layer, float distance, float angle) {
    float2 direction = float2(cos(angle), sin(angle));
    half3 sum = half3(0.0h);
    float weight = 0.0f;
    for (int index = 0; index < 10; index++) {
        float step = float(index) / 9.0f;
        float sampleWeight = 1.0f - step * 0.58f;
        sum += layer.sample(position - direction * distance * step).rgb * half(sampleWeight);
        weight += sampleWeight;
    }
    half alpha = layer.sample(position).a;
    return half4(sum / half(weight), alpha);
}
