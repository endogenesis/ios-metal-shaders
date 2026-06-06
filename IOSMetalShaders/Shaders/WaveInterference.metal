//
//  WaveInterference.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 06.06.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 waveInterference(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float waveA = sin(length(uv - float2(0.25f, 0.42f)) * 72.0f - time * 5.0f);
    float waveB = sin(length(uv - float2(0.76f, 0.58f)) * 66.0f - time * 4.2f);
    float2 gradient = float2(cos((uv.y + waveB) * 24.0f), sin((uv.x + waveA) * 22.0f));
    return layer.sample(position + gradient * (waveA + waveB) * 3.6f * amount);
}
