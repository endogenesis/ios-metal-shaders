//
//  Starfield.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.02.2026.
//

#include <metal_stdlib>
using namespace metal;

float starfieldHash(float2 value) {
    return fract(sin(dot(value, float2(127.1f, 311.7f))) * 43758.5453f);
}

[[ stitchable ]]
half4 starfield(float2 position, half4 color, float2 size, float time, float density) {
    (void)size;
    float2 moving = position + float2(time * 3.0f, time * 8.0f);
    float2 cell = floor(moving / 13.0f);
    float2 local = fract(moving / 13.0f);
    float2 starPosition = float2(starfieldHash(cell), starfieldHash(cell + 17.3f));
    float distanceToStar = length(local - starPosition);
    float visible = step(1.0f - clamp(density, 0.0f, 1.0f) * 0.48f, starfieldHash(cell + 41.0f));
    float twinkle = 0.55f + 0.45f * sin(time * 4.0f + starfieldHash(cell) * 20.0f);
    float star = (1.0f - smoothstep(0.015f, 0.11f, distanceToStar)) * visible * twinkle;
    half3 starColor = mix(half3(0.55h, 0.72h, 1.0h), half3(1.0h), half(starfieldHash(cell + 9.0f)));
    return half4(clamp(color.rgb + starColor * half(star), half3(0.0h), half3(1.0h)), color.a);
}
