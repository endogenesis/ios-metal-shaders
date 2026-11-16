//
//  ASCIIArt.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

// Original 5x7 bitmaps: space, dot, colon, dash, equals, plus, star, hash, percent, @.
constant uint asciiArtGlyphs[10][7] = {
    {0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 4, 0},
    {0, 4, 0, 0, 4, 0, 0},
    {0, 0, 0, 31, 0, 0, 0},
    {0, 0, 31, 0, 31, 0, 0},
    {0, 4, 4, 31, 4, 4, 0},
    {0, 21, 14, 31, 14, 21, 0},
    {10, 10, 31, 10, 31, 10, 10},
    {19, 19, 8, 4, 2, 25, 25},
    {14, 17, 29, 21, 29, 1, 30}
};

[[ stitchable ]]
half4 asciiArt(float2 position, SwiftUI::Layer layer, float2 size, float cellWidth, float colored) {
    half4 source = layer.sample(position);
    float2 cellSize = max(cellWidth, 6.0f) * float2(1.0f, 1.5f);
    float2 cell = floor(position / cellSize);
    float2 center = clamp((cell + 0.5f) * cellSize, float2(0.5f), max(size - 0.5f, float2(0.5f)));
    half4 sample = layer.sample(center);
    float3 base = float3(sample.rgb) / max(float(sample.a), 0.0001f);
    float luma = dot(base, float3(0.2126f, 0.7152f, 0.0722f));
    uint glyph = uint(clamp(round(pow(clamp(luma, 0.0f, 1.0f), 0.8f) * 9.0f), 0.0f, 9.0f));

    float2 gridPosition = position / cellSize * float2(6, 9);
    float2 local = fract(position / cellSize) * float2(6, 9) - float2(0.5f, 1.0f);
    int2 pixel = int2(floor(local));
    float ink = 0.0f;
    if (pixel.x >= 0 && pixel.x < 5 && pixel.y >= 0 && pixel.y < 7) {
        ink = float((asciiArtGlyphs[glyph][pixel.y] >> uint(pixel.x)) & 1u);
    }
    // Antialias bitmap edges in display pixels without a font texture or CPU text layout.
    float2 edge = min(fract(local), 1.0f - fract(local));
    float2 coverage = smoothstep(float2(0), max(fwidth(gridPosition) * 0.5f, float2(0.001f)), edge);
    ink *= coverage.x * coverage.y;
    float3 foreground = mix(float3(0.65f, 1.0f, 0.75f), max(base, float3(0.15f)), clamp(colored, 0.0f, 1.0f));
    float3 result = mix(float3(0.012f, 0.018f, 0.025f), foreground, ink);
    return half4(half3(result) * source.a, source.a);
}
