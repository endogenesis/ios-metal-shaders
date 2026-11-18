//
//  ElectricArc.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float arcHash(float2 p) {
    return fract(sin(dot(p, float2(127.1f, 311.7f))) * 43758.5453f);
}

static float arcNoise(float2 p) {
    float2 cell = floor(p);
    float2 f = fract(p);
    f = f * f * (3.0f - 2.0f * f);
    return mix(mix(arcHash(cell), arcHash(cell + float2(1, 0)), f.x),
               mix(arcHash(cell + float2(0, 1)), arcHash(cell + 1.0f), f.x), f.y);
}

static float2 arcPoint(float2 a, float2 b, float progress, float time, float seed, float amplitude) {
    float2 direction = b - a;
    float2 normal = float2(-direction.y, direction.x) / max(length(direction), 0.001f);
    float noise = arcNoise(float2(progress * 7.0f + seed, time * 6.0f)) - 0.5f;
    noise += (arcNoise(float2(progress * 19.0f + seed * 3.0f, time * 11.0f)) - 0.5f) * 0.45f;
    return mix(a, b, progress) + normal * noise * sin(progress * 3.14159265f) * amplitude;
}

static float arcSegmentDistance(float2 p, float2 a, float2 b) {
    float2 ab = b - a;
    float t = clamp(dot(p - a, ab) / max(dot(ab, ab), 0.0001f), 0.0f, 1.0f);
    return length(p - mix(a, b, t));
}

[[ stitchable ]]
half4 electricArc(float2 position, SwiftUI::Layer layer, float2 size,
                  float time, float2 pointer, float energy, float palette) {
    half4 source = layer.sample(position);
    if (source.a <= 0.0h || energy <= 0.0f) return source;
    float2 safeSize = max(size, float2(1.0f));
    float2 target = pointer * safeSize;
    float amplitude = min(safeSize.x, safeSize.y) * (0.06f + energy * 0.12f);
    float distance = 10000.0f;
    float branchDistance = 10000.0f;

    for (int bolt = 0; bolt < 3; ++bolt) {
        float2 origin = (bolt == 0 ? float2(0.08f, 0.2f) :
                         bolt == 1 ? float2(0.08f, 0.8f) : float2(0.92f, 0.5f)) * safeSize;
        float seed = float(bolt) * 17.7f;
        float2 previous = origin;
        for (int step = 1; step <= 20; ++step) {
            float2 next = arcPoint(origin, target, float(step) / 20.0f, time, seed, amplitude);
            distance = min(distance, arcSegmentDistance(position, previous, next));
            previous = next;
        }
        float2 fork = arcPoint(origin, target, 0.55f, time, seed, amplitude);
        float2 branchEnd = mix(origin, target, 0.75f) + float2(0.12f, bolt == 1 ? 0.22f : -0.22f) * safeSize;
        branchEnd = clamp(branchEnd, safeSize * 0.03f, safeSize * 0.97f);
        previous = fork;
        for (int step = 1; step <= 10; ++step) {
            float2 next = arcPoint(fork, branchEnd, float(step) / 10.0f, time, seed + 9.0f, amplitude * 0.5f);
            branchDistance = min(branchDistance, arcSegmentDistance(position, previous, next));
            previous = next;
        }
    }
    float width = 0.5f + energy * 0.8f;
    float core = exp(-pow(distance / width, 2.0f));
    core += exp(-pow(branchDistance / (width * 0.65f), 2.0f)) * 0.65f;
    float glow = exp(-distance / 6.0f) * 0.55f + exp(-branchDistance / 3.0f) * 0.24f;
    float pulse = 0.85f + 0.15f * sin(time * 17.0f + sin(time * 9.0f));
    float3 tint = mix(float3(0.12f, 0.45f, 1.0f), float3(0.7f, 0.12f, 1.0f), clamp(palette, 0.0f, 1.0f));
    float3 base = float3(source.rgb) / float(source.a);
    float3 result = base * (1.0f - energy * 0.45f) + (tint * glow + float3(core)) * energy * pulse;
    return half4(half3(clamp(result, 0.0f, 1.0f)) * source.a, source.a);
}
