//
//  NoiseDissolve.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.08.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 noiseDissolve(float2 position, half4 color, float time, float amount) {
float noise = fract(sin(dot(floor(position), float2(12.9898f, 78.233f)) + floor(time * 6.0f) * 0.13f) * 43758.5453f);
    float threshold = amount;
    float mask = smoothstep(threshold - 0.04f, threshold + 0.04f, noise);
    float edge = 1.0f - smoothstep(0.0f, 0.055f, abs(noise - threshold));
    half3 burningEdge = color.rgb + half3(1.0h, 0.32h, 0.04h) * half(edge * 0.65f);
    return half4(burningEdge, color.a * half(mask));
}
