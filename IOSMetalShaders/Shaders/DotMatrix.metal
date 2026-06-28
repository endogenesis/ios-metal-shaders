//
//  DotMatrix.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.06.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 dotMatrix(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float cellSize = mix(5.0f, 14.0f, amount);
    float2 cellCenter = (floor(position / cellSize) + 0.5f) * cellSize;
    half4 sampleColor = layer.sample(cellCenter);
    float2 local = fract(position / cellSize) - 0.5f;
    float dotMask = 1.0f - smoothstep(0.32f, 0.49f, length(local));
    half luminance = dot(sampleColor.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    dotMask *= 0.35f + float(luminance) * 0.65f;
    return half4(sampleColor.rgb * half(dotMask), sampleColor.a);
}
