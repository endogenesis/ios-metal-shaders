//
//  BurnDissolve.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.01.2026.
//

#include <metal_stdlib>
using namespace metal;

float burnDissolveHash(float2 value) {
    return fract(sin(dot(value, float2(127.1f, 269.5f))) * 43758.5453f);
}

float burnDissolveNoise(float2 position) {
    float2 cell = floor(position);
    float2 fraction = fract(position);
    float2 blend = fraction * fraction * (3.0f - 2.0f * fraction);
    float bottom = mix(
        burnDissolveHash(cell),
        burnDissolveHash(cell + float2(1.0f, 0.0f)),
        blend.x
    );
    float top = mix(
        burnDissolveHash(cell + float2(0.0f, 1.0f)),
        burnDissolveHash(cell + float2(1.0f, 1.0f)),
        blend.x
    );
    return mix(bottom, top, blend.y);
}

[[ stitchable ]]
half4 burnDissolve(float2 position, half4 color, float progress, float scale) {
    float safeScale = max(scale, 2.0f);
    float2 coordinate = position / safeScale;
    float noise = burnDissolveNoise(coordinate) * 0.7f;
    noise += burnDissolveNoise(coordinate * 2.1f + 7.3f) * 0.3f;

    float threshold = clamp(progress, 0.0f, 1.0f);
    float remaining = step(threshold, noise);
    float ember = (1.0f - smoothstep(0.0f, 0.075f, noise - threshold)) * remaining;
    half3 emberColor = mix(half3(1.0h, 0.12h, 0.01h), half3(1.0h, 0.72h, 0.08h), half(ember));
    half3 result = mix(color.rgb, emberColor, half(ember * 0.88f));

    return half4(result, color.a * half(remaining));
}
