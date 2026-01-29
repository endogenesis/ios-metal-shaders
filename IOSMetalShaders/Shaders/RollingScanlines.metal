//
//  RollingScanlines.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.01.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 rollingScanlines(float2 position, half4 color, float time, float intensity) {
    float safeIntensity = clamp(intensity, 0.0f, 0.85f);
    float fineLines = 0.5f + 0.5f * sin(position.y * 1.75f + time * 9.0f);
    float rollingPosition = fract(time * 0.22f) * 260.0f;
    float distanceToRoll = abs(position.y - rollingPosition);
    float roll = exp(-distanceToRoll * distanceToRoll / 210.0f);
    float brightness = 1.0f - fineLines * safeIntensity * 0.42f + roll * safeIntensity * 0.55f;
    return half4(clamp(color.rgb * half(brightness), half3(0.0h), half3(1.0h)), color.a);
}
