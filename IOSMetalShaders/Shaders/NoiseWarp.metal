//
//  NoiseWarp.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 noiseWarp(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float noiseX = sin(uv.y * 34.0f + time * 1.7f) + sin((uv.x + uv.y) * 19.0f - time);
    float noiseY = cos(uv.x * 29.0f - time * 1.3f) + cos((uv.x - uv.y) * 23.0f + time);
    float2 offset = float2(noiseX, noiseY) * 7.0f * amount;
    return layer.sample(position + offset);
}
