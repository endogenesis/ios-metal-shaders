//
//  PaperGrain.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 paperGrain(float2 position, half4 color, float amount) {
float grain = fract(sin(dot(floor(position * 0.75f), float2(12.9898f, 78.233f))) * 43758.5453f);
    float fiber = sin(position.x * 0.19f + sin(position.y * 0.07f) * 2.0f) * 0.5f + 0.5f;
    half texture = half((grain - 0.5f) * 0.12f + (fiber - 0.5f) * 0.05f);
    half3 warm = color.rgb * half3(1.02h, 0.98h, 0.9h) + texture;
    return half4(mix(color.rgb, warm, half(amount)), color.a);
}
