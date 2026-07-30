//
//  HeatHaze.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 31.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 heatHaze(float2 position, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float rise = uv.y * 34.0f - time * 3.2f;
    float wave = sin(rise + sin(uv.x * 17.0f + time)) + 0.45f * sin(rise * 1.9f - time);
    float taper = smoothstep(0.0f, 0.75f, 1.0f - uv.y);
    return position + float2(wave * amount * 6.0f * taper, sin(uv.x * 29.0f + time) * amount * 1.8f);
}
