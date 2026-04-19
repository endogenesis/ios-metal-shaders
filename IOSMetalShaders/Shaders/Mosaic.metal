//
//  Mosaic.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 mosaic(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float cellSize = mix(2.0f, 34.0f, amount);
    float2 samplePosition = (floor(position / cellSize) + 0.5f) * cellSize;
    half4 tile = layer.sample(samplePosition);
    float2 local = fract(position / cellSize);
    half grout = half(step(0.94f, max(local.x, local.y)) * amount * 0.28f);
    tile.rgb *= 1.0h - grout;
    return tile;
}
