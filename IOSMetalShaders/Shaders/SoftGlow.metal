//
//  SoftGlow.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 softGlow(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float radius = 5.0f + amount * 12.0f;
    half4 source = layer.sample(position);
    half3 blur = half3(0.0h);
    for (int index = 0; index < 8; ++index) {
        float angle = float(index) * 0.785398f;
        blur += layer.sample(position + float2(cos(angle), sin(angle)) * radius).rgb;
    }
    blur /= 8.0h;
    half3 screened = 1.0h - (1.0h - source.rgb) * (1.0h - blur);
    return half4(mix(source.rgb, screened, half(amount * 0.62f)), source.a);
}
