//
//  DataCorruption.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 dataCorruption(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 block = floor(position / float2(19.0f, 9.0f));
    float frame = floor(time * 15.0f);
    float random = fract(sin(dot(block, float2(19.19f, 73.73f)) + frame) * 951.1357f);
    float active = step(0.7f - amount * 0.28f, random);
    float shift = (random - 0.5f) * 72.0f * amount * active;
    half4 damaged = layer.sample(position + float2(shift, 0.0f));
    damaged.rgb = mix(damaged.rgb, half3(damaged.b, damaged.r, damaged.g), half(active * 0.62f));
    damaged.rgb = mix(damaged.rgb, 1.0h - damaged.rgb, half(step(0.94f, random) * amount));
    return damaged;
}
