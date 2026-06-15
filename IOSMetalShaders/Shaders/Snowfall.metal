//
//  Snowfall.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 snowfall(float2 position, half4 color, float time, float amount) {
float2 cellSize = float2(18.0f, 22.0f);
    float2 moving = position + float2(sin(time + position.y * 0.02f) * 5.0f, time * 32.0f);
    float2 cell = floor(moving / cellSize);
    float random = fract(sin(dot(cell, float2(127.1f, 311.7f))) * 43758.5453f);
    float2 local = fract(moving / cellSize) - float2(random, 0.5f);
    float flake = smoothstep(0.18f, 0.02f, length(local)) * step(1.0f - amount * 0.75f, random);
    half3 snowy = mix(color.rgb, half3(0.92h, 0.97h, 1.0h), half(flake));
    return half4(snowy, color.a);
}
