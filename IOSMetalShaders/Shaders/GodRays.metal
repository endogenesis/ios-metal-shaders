//
//  GodRays.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.06.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 godRays(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 lightPosition = size * float2(0.5f + sin(time * 0.45f) * 0.24f, 0.18f);
    float2 stepVector = (lightPosition - position) * (0.018f + amount * 0.012f);
    half3 rays = half3(0.0h);
    float2 samplePosition = position;
    half decay = 1.0h;
    for (int index = 0; index < 12; ++index) {
        samplePosition += stepVector;
        half3 sampleColor = layer.sample(samplePosition).rgb;
        half luminance = max(sampleColor.r, max(sampleColor.g, sampleColor.b));
        rays += sampleColor * smoothstep(0.58h, 1.0h, luminance) * decay;
        decay *= 0.88h;
    }
    half4 source = layer.sample(position);
    return half4(source.rgb + rays * half(amount * 0.08f), source.a);
}
