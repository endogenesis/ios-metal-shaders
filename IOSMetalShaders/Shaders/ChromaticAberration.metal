//
//  ChromaticAberration.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 chromaticAberration(
    float2 position,
    SwiftUI::Layer layer,
    float2 size,
    float amount
) {
    float2 center = size * 0.5f;
    float2 delta = position - center;
    float distanceFromCenter = length(delta);
    float2 direction = delta / max(distanceFromCenter, 1.0f);
    float edgeDistance = max(min(size.x, size.y) * 0.48f, 1.0f);
    float edgeAmount = smoothstep(0.0f, edgeDistance, distanceFromCenter) * amount;
    float2 offset = direction * edgeAmount;

    half4 source = layer.sample(position);
    half red = layer.sample(position + offset).r;
    half blue = layer.sample(position - offset).b;

    return half4(red, source.g, blue, source.a);
}
