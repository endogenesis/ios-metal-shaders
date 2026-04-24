//
//  LiquidGlass.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 liquidGlass(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float2 flow = float2(sin(uv.y * 22.0f + time * 1.4f), cos(uv.x * 19.0f - time * 1.1f));
    flow += float2(sin((uv.x + uv.y) * 31.0f - time), cos((uv.x - uv.y) * 27.0f + time));
    float2 offset = flow * 7.0f * amount;
    half4 refracted = layer.sample(position + offset);
    half highlight = half(pow(max(0.0f, dot(normalize(float3(flow, 1.5f)), normalize(float3(-0.4f, -0.6f, 1.0f)))), 18.0f));
    refracted.rgb += highlight * half3(0.22h, 0.28h, 0.3h) * half(amount);
    return refracted;
}
