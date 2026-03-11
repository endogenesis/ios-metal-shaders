//
//  BlueNoiseDither.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float blueNoiseValue(float2 position) {
    return fract(52.9829189f * fract(dot(position, float2(0.06711056f, 0.00583715f))));
}

[[ stitchable ]]
half4 blueNoiseDither(float2 position, half4 color, float amount, float levels) {
    float safeLevels = max(levels, 2.0f);
    float noise = (blueNoiseValue(position) - 0.5f) * clamp(amount, 0.0f, 1.0f);
    float3 adjusted = float3(color.rgb) + noise / safeLevels;
    half3 result = half3(floor(clamp(adjusted, 0.0f, 1.0f) * safeLevels + 0.5f) / safeLevels);
    return half4(result, color.a);
}
