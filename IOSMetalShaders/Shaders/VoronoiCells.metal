//
//  VoronoiCells.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float2 voronoiCellsHash(float2 value) {
    return fract(sin(float2(
        dot(value, float2(127.1f, 311.7f)),
        dot(value, float2(269.5f, 183.3f))
    )) * 43758.5453f);
}

[[ stitchable ]]
half4 voronoiCells(float2 position, half4 color, float scale, float amount) {
    float safeScale = max(scale, 4.0f);
    float2 coordinate = position / safeScale;
    float2 cell = floor(coordinate);
    float2 local = fract(coordinate);
    float nearest = 10.0f;
    float secondNearest = 10.0f;
    float cellValue = 0.0f;
    for (int y = -1; y <= 1; y++) {
        for (int x = -1; x <= 1; x++) {
            float2 neighbor = float2(float(x), float(y));
            float2 point = neighbor + voronoiCellsHash(cell + neighbor);
            float distanceToPoint = length(local - point);
            if (distanceToPoint < nearest) {
                secondNearest = nearest;
                nearest = distanceToPoint;
                cellValue = voronoiCellsHash(cell + neighbor + 8.0f).x;
            } else if (distanceToPoint < secondNearest) {
                secondNearest = distanceToPoint;
            }
        }
    }
    float border = 1.0f - smoothstep(0.025f, 0.085f, secondNearest - nearest);
    half3 faceted = color.rgb * half(0.72f + cellValue * 0.34f);
    faceted *= half(1.0f - border * 0.42f);
    return half4(mix(color.rgb, faceted, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
