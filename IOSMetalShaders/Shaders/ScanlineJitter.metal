//
//  ScanlineJitter.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 scanlineJitter(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float row = floor(position.y / 3.0f);
    float frame = floor(time * 18.0f);
    float random = fract(sin(row * 17.17f + frame * 3.71f) * 43758.5453f);
    float shift = (random - 0.5f) * 26.0f * amount * step(0.58f, random);
    half4 source = layer.sample(position + float2(shift, 0.0f));
    source.rgb *= half(0.9f + 0.1f * sin(position.y * 3.14159f));
    return source;
}
