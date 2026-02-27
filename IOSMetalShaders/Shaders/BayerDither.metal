//
//  BayerDither.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.02.2026.
//

#include <metal_stdlib>
using namespace metal;

constant float bayerDitherMatrix[16] = {
    0.0f, 8.0f, 2.0f, 10.0f,
    12.0f, 4.0f, 14.0f, 6.0f,
    3.0f, 11.0f, 1.0f, 9.0f,
    15.0f, 7.0f, 13.0f, 5.0f
};

[[ stitchable ]]
half4 bayerDither(float2 position, half4 color, float levels) {
    int x = int(position.x) & 3;
    int y = int(position.y) & 3;
    float threshold = (bayerDitherMatrix[y * 4 + x] + 0.5f) / 16.0f - 0.5f;
    float safeLevels = max(round(levels), 2.0f);
    float3 adjusted = float3(color.rgb) + threshold / safeLevels;
    half3 quantized = half3(floor(clamp(adjusted, 0.0f, 1.0f) * safeLevels) / safeLevels);
    return half4(quantized, color.a);
}
