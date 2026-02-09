//
//  CRTSyncLoss.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float crtSyncLossHash(float2 value) {
    return fract(sin(dot(value, float2(83.17f, 317.91f))) * 43758.5453f);
}

[[ stitchable ]]
half4 crtSyncLoss(float2 position, SwiftUI::Layer layer, float time, float strength) {
    float band = floor(position.y / 13.0f);
    float frame = floor(time * 9.0f);
    float noise = crtSyncLossHash(float2(band, frame));
    float active = step(0.62f, noise);
    float horizontal = (noise * 2.0f - 1.0f) * strength * active;
    float vertical = sin(time * 12.0f + position.y * 0.09f) * 3.0f * active;
    half4 shifted = layer.sample(position + float2(horizontal, vertical));
    half red = layer.sample(position + float2(horizontal * 0.72f, vertical)).r;
    half blue = layer.sample(position + float2(horizontal * 0.88f, -vertical)).b;
    half scan = half(0.9f + 0.1f * sin(position.y * 1.55f));
    return half4(half3(red, shifted.g, blue) * scan, shifted.a);
}
