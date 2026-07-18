//
//  CompressionArtifacts.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 compressionArtifacts(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float blockSize = mix(5.0f, 22.0f, amount);
    float2 center = (floor(position / blockSize) + 0.5f) * blockSize;
    half4 source = layer.sample(position);
    half3 block = layer.sample(center).rgb;
    float levels = mix(32.0f, 5.0f, amount);
    block = floor(block * half(levels) + 0.5h) / half(levels);
    float2 local = fract(position / blockSize);
    half edge = half(step(0.92f, max(local.x, local.y)) * amount * 0.18f);
    return half4(mix(source.rgb, block, half(amount * 0.72f)) - edge, source.a);
}
