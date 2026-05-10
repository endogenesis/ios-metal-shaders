//
//  CheckerPattern.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.05.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 checkerPattern(float2 position, half4 color, float amount) {
float scale = mix(34.0f, 9.0f, amount);
    float2 cell = floor(position / scale);
    float checker = fmod(cell.x + cell.y, 2.0f);
    half3 tint = checker < 1.0f ? half3(0.08h, 0.1h, 0.16h) : half3(0.9h, 0.78h, 0.3h);
    half blend = half(0.18f + amount * 0.42f);
    return half4(mix(color.rgb, color.rgb * 0.45h + tint * 0.55h, blend), color.a);
}
