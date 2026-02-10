//
//  Fire.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 10.02.2026.
//

#include <metal_stdlib>
using namespace metal;

float fireHash(float2 value) {
    return fract(sin(dot(value, float2(127.1f, 311.7f))) * 43758.5453f);
}

float fireNoise(float2 position) {
    float2 cell = floor(position);
    float2 fraction = fract(position);
    float2 blend = fraction * fraction * (3.0f - 2.0f * fraction);
    float bottom = mix(fireHash(cell), fireHash(cell + float2(1.0f, 0.0f)), blend.x);
    float top = mix(fireHash(cell + float2(0.0f, 1.0f)), fireHash(cell + 1.0f), blend.x);
    return mix(bottom, top, blend.y);
}

[[ stitchable ]]
half4 fire(float2 position, half4 color, float2 size, float time, float intensity) {
    float2 uv = position / max(size, float2(1.0f));
    float height = 1.0f - uv.y;
    float noise = fireNoise(float2(uv.x * 8.0f, uv.y * 5.0f - time * 1.8f));
    noise += fireNoise(float2(uv.x * 16.0f + time, uv.y * 9.0f - time * 2.6f)) * 0.45f;
    float flame = 1.0f - smoothstep(0.18f, 0.74f, height + noise * 0.32f);
    flame *= 1.0f - smoothstep(0.28f, 1.0f, height);
    flame *= clamp(intensity, 0.0f, 1.0f);
    half3 red = half3(1.0h, 0.08h, 0.0h);
    half3 yellow = half3(1.0h, 0.76h, 0.08h);
    half3 flameColor = mix(red, yellow, half(clamp(flame * 1.5f, 0.0f, 1.0f)));
    return half4(clamp(color.rgb + flameColor * half(flame), half3(0.0h), half3(1.0h)), color.a);
}
