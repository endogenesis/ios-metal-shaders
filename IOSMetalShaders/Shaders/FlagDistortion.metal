//
//  FlagDistortion.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 flagDistortion(float2 position, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float envelope = sin(uv.x * 3.1415926f);
    float wave = sin(uv.x * 15.0f - time * 3.0f) * 10.0f;
    wave += sin(uv.x * 29.0f - time * 4.7f) * 3.0f;
    float vertical = wave * envelope * amount;
    float horizontal = sin(uv.y * 8.0f + time * 2.0f) * envelope * amount * 3.0f;
    return position + float2(horizontal, vertical);
}
