//
//  ChromaKey.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 chromaKey(float2 position, half4 color, float amount) {
(void)position;
    half greenDominance = color.g - max(color.r, color.b);
    half threshold = half(mix(0.42f, 0.04f, amount));
    half keep = 1.0h - smoothstep(threshold, threshold + 0.12h, greenDominance);
    half spill = smoothstep(0.0h, 0.28h, greenDominance);
    half3 despilled = half3(color.r + spill * 0.08h, color.g * (1.0h - spill * 0.55h), color.b + spill * 0.05h);
    return half4(despilled, color.a * keep);
}
