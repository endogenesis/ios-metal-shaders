//
//  WaterDroplets.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.02.2026.
//

#include <metal_stdlib>
using namespace metal;

float waterDropletsHash(float2 value) {
    return fract(sin(dot(value, float2(113.7f, 271.9f))) * 43758.5453f);
}

[[ stitchable ]]
float2 waterDroplets(float2 position, float2 size, float time, float strength) {
    float2 safeSize = max(size, float2(1.0f));
    float2 gridPosition = position / safeSize * float2(6.0f, 4.0f);
    float2 cell = floor(gridPosition);
    float2 randomCenter = float2(
        waterDropletsHash(cell),
        waterDropletsHash(cell + 19.4f)
    );
    randomCenter += 0.08f * float2(sin(time + cell.x), cos(time * 0.8f + cell.y));
    float2 local = fract(gridPosition) - randomCenter;
    float distanceToDrop = length(local);
    float ripple = sin(distanceToDrop * 34.0f - time * 4.2f);
    ripple *= exp(-distanceToDrop * 9.0f) * (1.0f - smoothstep(0.16f, 0.62f, distanceToDrop));
    float2 direction = local / max(distanceToDrop, 0.02f);
    return position + direction * ripple * strength;
}
