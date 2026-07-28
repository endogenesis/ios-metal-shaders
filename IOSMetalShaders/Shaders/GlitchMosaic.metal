//
//  GlitchMosaic.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 glitchMosaic(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float blockSize = mix(12.0f, 36.0f, amount);
    float2 block = floor(position / blockSize);
    float frame = floor(time * 7.0f);
    float random = fract(sin(dot(block, float2(37.1f, 113.7f)) + frame) * 43758.5453f);
    float2 center = (block + 0.5f) * blockSize;
    float2 shift = float2(random - 0.5f, fract(random * 7.0f) - 0.5f) * blockSize * amount * 3.0f;
    half4 tile = layer.sample(center + shift);
    tile.rgb = random > 0.8f ? tile.brg : tile.rgb;
    return tile;
}
