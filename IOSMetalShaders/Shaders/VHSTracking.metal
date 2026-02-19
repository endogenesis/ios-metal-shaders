//
//  VHSTracking.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 vhsTracking(float2 position, SwiftUI::Layer layer, float time, float strength) {
    float movingBand = fract(position.y / 92.0f - time * 0.32f);
    float tracking = 1.0f - smoothstep(0.0f, 0.2f, abs(movingBand - 0.5f));
    float wobble = sin(position.y * 0.085f + time * 7.0f) * strength * tracking;
    float jitter = sin(position.y * 1.9f + time * 31.0f) * strength * 0.08f;
    float shift = wobble + jitter;
    half4 source = layer.sample(position + float2(shift, 0.0f));
    half red = layer.sample(position + float2(shift + strength * 0.08f, 0.0f)).r;
    half blue = layer.sample(position + float2(shift - strength * 0.08f, 0.0f)).b;
    half brightness = half(1.0f + tracking * 0.16f);
    return half4(clamp(half3(red, source.g, blue) * brightness, half3(0.0h), half3(1.0h)), source.a);
}
