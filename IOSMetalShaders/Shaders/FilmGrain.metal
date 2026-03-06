//
//  FilmGrain.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float filmGrainHash(float2 value) {
    return fract(sin(dot(value, float2(12.9898f, 78.233f))) * 43758.5453f);
}

[[ stitchable ]]
half4 filmGrain(float2 position, half4 color, float time, float amount) {
    float frame = floor(time * 24.0f);
    float fine = filmGrainHash(position + float2(frame * 17.0f, frame * 7.0f));
    float coarse = filmGrainHash(floor(position * 0.45f) + frame * 3.0f);
    float grain = ((fine - 0.5f) * 0.72f + (coarse - 0.5f) * 0.28f) * amount;
    half luminanceWeight = half(0.45f + dot(float3(color.rgb), float3(0.2126f, 0.7152f, 0.0722f)) * 0.55f);
    half3 result = clamp(color.rgb + half3(half(grain) * luminanceWeight), half3(0.0h), half3(1.0h));
    return half4(result, color.a);
}
