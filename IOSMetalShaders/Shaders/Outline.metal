//
//  Outline.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 outline(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float amount
) {
    half4 source = layer.sample(position);
    float clampedAmount = clamp(amount, 0.0f, 1.0f);
    float radius = 1.0f + clampedAmount * 3.5f;
    float2 maximumPosition = max(size - float2(1.0f), float2(0.0f));
    float2 minimumPosition = min(float2(1.0f), maximumPosition);
    half3 left = layer.sample(
        clamp(position - float2(radius, 0.0f), minimumPosition, maximumPosition)
    ).rgb;
    half3 right = layer.sample(
        clamp(position + float2(radius, 0.0f), minimumPosition, maximumPosition)
    ).rgb;
    half3 up = layer.sample(
        clamp(position - float2(0.0f, radius), minimumPosition, maximumPosition)
    ).rgb;
    half3 down = layer.sample(
        clamp(position + float2(0.0f, radius), minimumPosition, maximumPosition)
    ).rgb;
    half edge = length(right - left) + length(down - up);
    half line = smoothstep(0.08h, 0.34h, edge) * half(clampedAmount);
    half3 outlinedColor = mix(source.rgb, half3(0.04h), line);

    return half4(outlinedColor, source.a);
}
