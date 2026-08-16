//
//  DisplacementTransition.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 displacementTransition(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float noise = sin(uv.y * 37.0f + sin(uv.x * 19.0f) * 2.0f) * 0.5f + 0.5f;
    float front = smoothstep(amount - 0.08f, amount + 0.08f, uv.x + (noise - 0.5f) * 0.24f);
    float2 offset = float2((1.0f - front) * amount * 85.0f, (noise - 0.5f) * amount * 18.0f);
    half4 displaced = layer.sample(position + offset);
    displaced.a *= half(front);
    return displaced;
}
