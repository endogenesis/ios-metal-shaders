//
//  MacroblockError.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float macroblockHash(float2 value) {
    return fract(sin(dot(value, float2(127.1f, 311.7f))) * 43758.5453f);
}

[[ stitchable ]]
half4 macroblockError(
    float2 position,
    SwiftUI::Layer layer,
    float time,
    float blockSize,
    float displacement
) {
    float safeBlockSize = max(blockSize, 4.0f);
    float2 block = floor(position / safeBlockSize);
    float frame = floor(time * 8.0f);
    float noise = macroblockHash(block + float2(frame, frame * 0.37f));
    float active = step(0.68f, noise);
    float shift = (noise * 2.0f - 1.0f) * displacement * active;

    half4 base = layer.sample(position + float2(shift, 0.0f));
    half red = layer.sample(position + float2(shift * 0.75f + displacement * 0.2f * active, 0.0f)).r;
    half blue = layer.sample(position + float2(shift * 0.75f - displacement * 0.2f * active, 0.0f)).b;
    float quantized = floor(float(base.g) * 12.0f) / 12.0f;

    return half4(red, half(mix(float(base.g), quantized, active * 0.7f)), blue, base.a);
}
