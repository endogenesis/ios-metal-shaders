//
//  Datamosh.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 datamosh(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 block = floor(position / float2(28.0f, 12.0f));
    float frame = floor(time * 7.0f);
    float noise = fract(sin(dot(block + frame, float2(41.3f, 289.1f))) * 15731.743f);
    float active = step(0.58f, noise) * amount;
    float2 offset = float2((noise - 0.5f) * 90.0f * active, sin(time + block.x) * 4.0f * active);
    half4 source = layer.sample(position + offset);
    source.r = layer.sample(position + offset * 1.25f).r;
    source.b = layer.sample(position - offset * 0.35f).b;
    return source;
}
