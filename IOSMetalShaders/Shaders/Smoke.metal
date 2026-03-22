//
//  Smoke.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float smokeHash(float2 value) {
    return fract(sin(dot(value, float2(127.1f, 311.7f))) * 43758.5453f);
}

float smokeNoise(float2 position) {
    float2 cell = floor(position);
    float2 fraction = fract(position);
    float2 blend = fraction * fraction * (3.0f - 2.0f * fraction);
    float bottom = mix(smokeHash(cell), smokeHash(cell + float2(1.0f, 0.0f)), blend.x);
    float top = mix(smokeHash(cell + float2(0.0f, 1.0f)), smokeHash(cell + 1.0f), blend.x);
    return mix(bottom, top, blend.y);
}

float smokeFBM(float2 position) {
    float value = 0.0f;
    float amplitude = 0.55f;
    for (int octave = 0; octave < 4; octave++) {
        value += smokeNoise(position) * amplitude;
        position = position * 2.03f + 7.1f;
        amplitude *= 0.5f;
    }
    return value;
}

[[ stitchable ]]
half4 smoke(float2 position, half4 color, float2 size, float time, float amount) {
    float2 uv = position / max(size, float2(1.0f));
    float2 flow = float2(uv.x * 3.4f + sin(uv.y * 8.0f + time) * 0.18f, uv.y * 3.1f - time * 0.32f);
    float density = smokeFBM(flow) - 0.43f;
    density = smoothstep(0.0f, 0.48f, density) * clamp(amount, 0.0f, 1.0f);
    half3 smokeColor = mix(half3(0.34h, 0.38h, 0.46h), half3(0.88h, 0.91h, 0.94h), half(density));
    return half4(mix(color.rgb, smokeColor, half(density * 0.68f)), color.a);
}
