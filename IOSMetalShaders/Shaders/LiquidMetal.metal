//
//  LiquidMetal.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float liquidMetalHeight(float2 position, SwiftUI::Layer layer, float2 size,
                               float time, float2 pointer) {
    float scale = max(min(size.x, size.y), 1.0f);
    float2 p = (position - size * 0.5f) / scale;
    float2 touch = (position - pointer * size) / scale;
    float radiusSquared = dot(touch, touch);
    half4 sample = layer.sample(position);
    float luma = dot(float3(sample.rgb) / max(float(sample.a), 0.0001f), float3(0.2126f, 0.7152f, 0.0722f));
    float waves = sin(p.x * 7.0f + time + sin(p.y * 5.0f - time * 0.6f));
    waves += sin(p.y * 9.0f - time * 0.8f + p.x * 3.0f) * 0.55f;
    return waves * 0.07f - exp(-radiusSquared * 32.0f) * 0.22f + luma * 0.025f;
}

[[ stitchable ]]
half4 liquidMetal(float2 position, SwiftUI::Layer layer, float2 size,
                  float time, float2 pointer, float amount) {
    half4 source = layer.sample(position);
    if (source.a <= 0.0h || amount <= 0.0f) return source;

    float2 safeSize = max(size, float2(1.0f));
    float dx = liquidMetalHeight(position + float2(2, 0), layer, safeSize, time, pointer)
             - liquidMetalHeight(position - float2(2, 0), layer, safeSize, time, pointer);
    float dy = liquidMetalHeight(position + float2(0, 2), layer, safeSize, time, pointer)
             - liquidMetalHeight(position - float2(0, 2), layer, safeSize, time, pointer);
    float slopeScale = min(safeSize.x, safeSize.y) * 0.25f;
    float3 normal = normalize(float3(-dx * slopeScale, -dy * slopeScale, 1.0f));
    float3 reflected = reflect(float3(0, 0, -1), normal);

    // An analytic studio environment: dark horizon and two broad white strip lights.
    float horizon = smoothstep(-0.12f, 0.16f, reflected.y);
    float3 chrome = mix(float3(0.035f, 0.05f, 0.075f), float3(0.52f, 0.64f, 0.76f), horizon);
    float stripA = exp(-pow((reflected.x + reflected.y * 0.4f - 0.25f) * 13.0f, 2.0f));
    float stripB = exp(-pow((reflected.x - reflected.y * 0.65f + 0.45f) * 20.0f, 2.0f));
    chrome += stripA * float3(0.85f, 0.88f, 0.92f) + stripB * float3(0.5f, 0.56f, 0.65f);
    float fresnel = pow(1.0f - max(normal.z, 0.0f), 5.0f);
    chrome += fresnel * 0.3f;
    float3 base = float3(source.rgb) / float(source.a);
    chrome *= 0.8f + base * 0.2f;
    chrome = chrome / (1.0f + chrome * 0.4f);
    return half4(half3(clamp(mix(base, chrome, clamp(amount, 0.0f, 1.0f)), 0.0f, 1.0f)) * source.a, source.a);
}
