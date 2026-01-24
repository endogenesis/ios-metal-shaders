//
//  FeedbackLoop.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 feedbackLoop(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
    float2 center = size * 0.5f;
    float2 delta = position - center;
    float distanceFromCenter = max(length(delta), 1.0f);
    float2 direction = delta / distanceFromCenter;
    float2 perpendicular = float2(-direction.y, direction.x);
    half4 source = layer.sample(position);
    half3 sum = source.rgb;
    float weight = 1.0f;

    for (int index = 1; index <= 5; index++) {
        float step = float(index) / 5.0f;
        float wobble = sin(time * 1.8f + step * 8.0f) * amount * 0.24f * step;
        float2 offset = -direction * amount * step + perpendicular * wobble;
        half3 echo = layer.sample(position + offset).rgb;
        echo *= half3(1.0h, half(1.0f - step * 0.08f), half(1.0f - step * 0.14f));
        float echoWeight = 1.0f - step * 0.13f;
        sum += echo * half(echoWeight);
        weight += echoWeight;
    }

    return half4(sum / half(weight), source.a);
}
