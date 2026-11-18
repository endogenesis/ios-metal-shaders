//
//  StainedGlass.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.11.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

static float2 stainedGlassHash(float2 value) {
    return fract(sin(float2(dot(value, float2(127.1f, 311.7f)),
                            dot(value, float2(269.5f, 183.3f)))) * 43758.5453f);
}

[[ stitchable ]]
half4 stainedGlass(float2 position, SwiftUI::Layer layer, float2 size, float cellSize, float seamWidth) {
    half4 source = layer.sample(position);
    float scale = max(cellSize, 8.0f);
    float2 coordinate = position / scale;
    float2 cell = floor(coordinate);
    float2 nearestPoint = cell;
    float2 nearestCell = cell;
    float nearestDistance = 100.0f;
    for (int y = -1; y <= 1; ++y) {
        for (int x = -1; x <= 1; ++x) {
            float2 candidate = cell + float2(x, y);
            float2 point = candidate + 0.2f + stainedGlassHash(candidate) * 0.6f;
            float squaredDistance = dot(point - coordinate, point - coordinate);
            if (squaredDistance < nearestDistance) {
                nearestDistance = squaredDistance;
                nearestPoint = point;
                nearestCell = candidate;
            }
        }
    }
    // Distance to the actual bisector, so the lead has a consistent width in points.
    float edgeDistance = 100.0f;
    float2 edgeNormal = float2(1, 0);
    for (int y = -2; y <= 2; ++y) {
        for (int x = -2; x <= 2; ++x) {
            float2 candidate = nearestCell + float2(x, y);
            float2 point = candidate + 0.2f + stainedGlassHash(candidate) * 0.6f;
            float2 separation = point - nearestPoint;
            if (dot(separation, separation) < 0.0001f) continue;
            float2 normal = normalize(separation);
            float distance = dot((point + nearestPoint) * 0.5f - coordinate, normal);
            if (distance < edgeDistance) {
                edgeDistance = distance;
                edgeNormal = normal;
            }
        }
    }
    float2 samplePosition = clamp(nearestPoint * scale, float2(0.5f), max(size - 0.5f, float2(0.5f)));
    half4 sample = layer.sample(samplePosition);
    float3 glass = float3(sample.rgb) / max(float(sample.a), 0.0001f);
    float2 grain = position / scale;
    float relief = sin(grain.x * 18.0f + sin(grain.y * 13.0f)) * sin(grain.y * 21.0f);
    glass *= 0.88f + 0.12f * relief;
    float rim = exp(-max(edgeDistance * scale - seamWidth, 0.0f) * 0.55f);
    glass += rim * 0.14f;
    float light = 0.045f + 0.075f * max(dot(edgeNormal, normalize(float2(-1, -1))), 0.0f);
    float aa = max(fwidth(edgeDistance * scale), 0.3f);
    float lead = 1.0f - smoothstep(seamWidth - aa, seamWidth + aa, edgeDistance * scale);
    float3 result = mix(glass, float3(light * 0.8f, light * 0.9f, light), lead);
    return half4(half3(clamp(result, 0.0f, 1.0f)) * source.a, source.a);
}
