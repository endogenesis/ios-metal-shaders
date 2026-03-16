//
//  ZoomBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 zoomBlur(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
    float2 delta = position - size * 0.5f;
    float2 direction = delta / max(length(delta), 1.0f);
    half3 sum = half3(0.0h);
    float weight = 0.0f;
    for (int index = 0; index < 9; index++) {
        float step = float(index) / 8.0f;
        float sampleWeight = 1.0f - step * 0.42f;
        sum += layer.sample(position - direction * amount * step).rgb * half(sampleWeight);
        weight += sampleWeight;
    }
    half alpha = layer.sample(position).a;
    return half4(sum / half(weight), alpha);
}
