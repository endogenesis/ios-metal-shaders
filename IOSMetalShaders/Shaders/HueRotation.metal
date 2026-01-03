//
//  HueRotation.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.01.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 hueRotation(float2 position, half4 color, float angle) {
    (void)position;

    float3 rgb = float3(color.rgb);
    float y = dot(rgb, float3(0.299f, 0.587f, 0.114f));
    float i = dot(rgb, float3(0.596f, -0.275f, -0.321f));
    float q = dot(rgb, float3(0.212f, -0.523f, 0.311f));
    float sine = sin(angle);
    float cosine = cos(angle);
    float rotatedI = i * cosine - q * sine;
    float rotatedQ = i * sine + q * cosine;

    float3 rotated = float3(
        y + 0.956f * rotatedI + 0.621f * rotatedQ,
        y - 0.272f * rotatedI - 0.647f * rotatedQ,
        y - 1.106f * rotatedI + 1.703f * rotatedQ
    );

    return half4(half3(clamp(rotated, 0.0f, 1.0f)), color.a);
}
