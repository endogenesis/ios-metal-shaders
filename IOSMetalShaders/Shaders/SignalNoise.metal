//
//  SignalNoise.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 signalNoise(float2 position, half4 color, float time, float amount) {
float frame = floor(time * 24.0f);
    float noiseA = fract(sin(dot(position, float2(17.13f, 91.7f)) + frame) * 43758.5453f);
    float noiseB = fract(sin(dot(position.yx, float2(63.7f, 12.1f)) - frame * 1.7f) * 23421.631f);
    half3 chroma = half3(noiseA, (noiseA + noiseB) * 0.5f, noiseB);
    half band = half(sin(position.y * 0.11f + time * 8.0f) * 0.04f * amount);
    return half4(mix(color.rgb, chroma, half(amount * 0.48f)) + band, color.a);
}
