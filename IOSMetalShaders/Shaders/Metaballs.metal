//
//  Metaballs.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 metaballs(float2 position, half4 color, float time, float amount) {
float2 p = position * 0.012f;
    float2 a = float2(5.0f + sin(time) * 2.2f, 4.0f + cos(time * 1.3f) * 2.0f);
    float2 b = float2(12.0f + cos(time * 0.8f) * 2.8f, 7.0f + sin(time * 1.1f) * 2.4f);
    float2 c = float2(8.0f + sin(time * 1.5f) * 3.0f, 13.0f + cos(time * 0.7f) * 2.2f);
    float field = 1.5f / max(dot(p - a, p - a), 0.08f);
    field += 1.8f / max(dot(p - b, p - b), 0.08f);
    field += 1.6f / max(dot(p - c, p - c), 0.08f);
    float blob = smoothstep(0.72f, 1.05f, field);
    half3 plasma = mix(half3(0.05h, 0.08h, 0.2h), half3(0.24h, 0.95h, 0.78h), half(blob));
    return half4(mix(color.rgb, plasma, half(amount * 0.86f)), color.a);
}
