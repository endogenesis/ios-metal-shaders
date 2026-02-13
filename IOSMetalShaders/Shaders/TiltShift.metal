//
//  TiltShift.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 tiltShift(float2 position, SwiftUI::Layer layer, float2 size, float radius) {
    half4 source = layer.sample(position);
    float normalizedY = position.y / max(size.y, 1.0f);
    float blurAmount = smoothstep(0.14f, 0.47f, abs(normalizedY - 0.5f));
    float sampleRadius = radius * blurAmount;
    half3 sum = source.rgb;

    for (int index = 0; index < 8; index++) {
        float angle = float(index) * 0.7853982f;
        float2 offset = float2(cos(angle), sin(angle)) * sampleRadius;
        sum += layer.sample(position + offset).rgb;
    }

    return half4(mix(source.rgb, sum / 9.0h, half(blurAmount)), source.a);
}
