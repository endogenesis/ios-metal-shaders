//
//  Embroidery.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float2 embroideryThread(float2 p, float2 a, float2 b) {
    float2 ab = b - a;
    float t = clamp(dot(p - a, ab) / max(dot(ab, ab), 0.0001f), 0.0f, 1.0f);
    float2 offset = p - mix(a, b, t);
    float side = dot(offset, normalize(float2(-ab.y, ab.x)));
    return float2(length(offset), side);
}

[[ stitchable ]]
half4 embroidery(float2 position, SwiftUI::Layer layer, float2 size, float stitchSize, float relief) {
    half4 source = layer.sample(position);
    float scale = max(stitchSize, 6.0f);
    float2 cell = floor(position / scale);
    float2 local = fract(position / scale) * scale;
    float2 center = clamp((cell + 0.5f) * scale, float2(0.5f), max(size - 0.5f, float2(0.5f)));
    half4 sample = layer.sample(center);
    float3 threadColor = float3(sample.rgb) / max(float(sample.a), 0.0001f);
    float radius = scale * 0.075f;
    float2 under = embroideryThread(local, float2(0.18f, 0.18f) * scale, float2(0.82f, 0.82f) * scale);
    float2 over = embroideryThread(local, float2(0.18f, 0.82f) * scale, float2(0.82f, 0.18f) * scale);
    float aa = max(length(fwidth(position)) * 0.45f, 0.25f);
    float underMask = 1.0f - smoothstep(radius - aa, radius + aa, under.x);
    float overMask = 1.0f - smoothstep(radius - aa, radius + aa, over.x);

    float2 weavePhase = position * 3.14159265f / 1.8f;
    float2 weaveAA = 1.0f - smoothstep(float2(1), float2(3), fwidth(weavePhase));
    float weave = sin(weavePhase.x) * sin(weavePhase.y) * weaveAA.x * weaveAA.y;
    float3 fabric = float3(0.08f, 0.07f, 0.06f) * (1.0f + weave * 0.18f);
    float underNormal = clamp(under.y / radius, -1.0f, 1.0f);
    float overNormal = clamp(over.y / radius, -1.0f, 1.0f);
    float underLight = mix(0.85f, 0.55f + 0.5f * sqrt(max(1.0f - underNormal * underNormal, 0.0f)) - underNormal * 0.2f, relief);
    float overLight = mix(1.0f, 0.65f + 0.55f * sqrt(max(1.0f - overNormal * overNormal, 0.0f)) - overNormal * 0.2f, relief);
    float fiberPhase = (local.x + local.y) * 5.0f;
    float fiberAA = 1.0f - smoothstep(1.0f, 3.0f, fwidth(fiberPhase));
    float fibers = 1.0f + sin(fiberPhase) * 0.1f * fiberAA * relief;
    float3 result = mix(fabric, threadColor * underLight * fibers, underMask);
    // The second diagonal passes over the first, leaving a small contact shadow.
    float shadow = exp(-over.x / max(radius * 2.0f, 0.1f)) * underMask * (1.0f - overMask);
    result *= 1.0f - shadow * relief * 0.25f;
    result = mix(result, threadColor * overLight * fibers, overMask);
    return half4(half3(clamp(result, 0.0f, 1.0f)) * source.a, source.a);
}
