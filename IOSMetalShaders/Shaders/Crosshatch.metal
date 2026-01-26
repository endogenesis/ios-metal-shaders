//
//  Crosshatch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.01.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 crosshatch(float2 position, half4 color, float spacing, float strength) {
    float luminance = dot(float3(color.rgb), float3(0.2126f, 0.7152f, 0.0722f));
    float safeSpacing = max(spacing, 2.0f);
    float diagonalA = abs(fract((position.x + position.y) / safeSpacing) - 0.5f);
    float diagonalB = abs(fract((position.x - position.y) / safeSpacing) - 0.5f);
    float lineA = 1.0f - smoothstep(0.06f, 0.13f, diagonalA);
    float lineB = 1.0f - smoothstep(0.06f, 0.13f, diagonalB);
    float shadows = smoothstep(0.2f, 0.85f, 1.0f - luminance);
    float deepShadows = smoothstep(0.55f, 0.95f, 1.0f - luminance);
    float ink = clamp(lineA * shadows + lineB * deepShadows, 0.0f, 1.0f);
    half darkening = half(1.0f - ink * clamp(strength, 0.0f, 1.0f));
    return half4(color.rgb * darkening, color.a);
}
