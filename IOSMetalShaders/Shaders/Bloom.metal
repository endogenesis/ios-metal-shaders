//
//  Bloom.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.04.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 bloom(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 3.0f + amount * 16.0f;
    half4 source = layer.sample(position);
    half3 glow = half3(0.0h);
    glow += layer.sample(position + float2(radius, 0.0f)).rgb;
    glow += layer.sample(position - float2(radius, 0.0f)).rgb;
    glow += layer.sample(position + float2(0.0f, radius)).rgb;
    glow += layer.sample(position - float2(0.0f, radius)).rgb;
    glow += layer.sample(position + float2(radius * 0.7f, radius * 0.7f)).rgb;
    glow += layer.sample(position - float2(radius * 0.7f, radius * 0.7f)).rgb;
    glow /= 6.0h;
    half brightness = max(glow.r, max(glow.g, glow.b));
    glow *= smoothstep(0.48h, 0.9h, brightness);
    return half4(source.rgb + glow * half(amount * 0.75f), source.a);
}
