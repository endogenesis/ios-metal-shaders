//
//  BlockDisplacement.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float blockDisplacementHash(float2 value) {
    return fract(sin(dot(value, float2(149.3f, 317.7f))) * 43758.5453f);
}

[[ stitchable ]]
half4 blockDisplacement(float2 position, SwiftUI::Layer layer, float time, float blockSize, float strength) {
    float safeBlockSize = max(blockSize, 4.0f);
    float2 block = floor(position / safeBlockSize);
    float frame = floor(time * 7.0f);
    float random = blockDisplacementHash(block + float2(frame, frame * 0.31f));
    float active = step(0.58f, random);
    float shift = (random * 2.0f - 1.0f) * strength * active;
    half4 displaced = layer.sample(position + float2(shift, 0.0f));
    half quantize = half(10.0f + blockDisplacementHash(block.yx) * 14.0f);
    displaced.rgb = floor(displaced.rgb * quantize) / quantize;
    return displaced;
}
