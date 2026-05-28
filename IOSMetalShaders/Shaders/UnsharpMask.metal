//
//  UnsharpMask.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 unsharpMask(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 1.5f + amount * 3.5f;
    half4 source = layer.sample(position);
    half3 blur = layer.sample(position + float2(radius, 0.0f)).rgb;
    blur += layer.sample(position - float2(radius, 0.0f)).rgb;
    blur += layer.sample(position + float2(0.0f, radius)).rgb;
    blur += layer.sample(position - float2(0.0f, radius)).rgb;
    blur *= 0.25h;
    half3 sharpened = source.rgb + (source.rgb - blur) * half(amount * 1.8f);
    return half4(clamp(sharpened, half3(0.0h), half3(1.0h)), source.a);
}
