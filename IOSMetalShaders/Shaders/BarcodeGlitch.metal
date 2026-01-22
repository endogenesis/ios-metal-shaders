//
//  BarcodeGlitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float barcodeGlitchHash(float2 value) {
    return fract(sin(dot(value, float2(159.7f, 271.9f))) * 43758.5453f);
}

[[ stitchable ]]
half4 barcodeGlitch(float2 position, SwiftUI::Layer layer, float time, float strength) {
    float bar = floor(position.x / 6.0f);
    float frame = floor(time * 12.0f);
    float noise = barcodeGlitchHash(float2(bar, frame));
    float active = step(0.38f, noise);
    float shift = (noise * 2.0f - 1.0f) * strength * active;

    half4 shifted = layer.sample(position + float2(shift, 0.0f));
    half red = layer.sample(position + float2(shift * 0.68f, 0.0f)).r;
    half blue = layer.sample(position + float2(shift * 0.86f, 0.0f)).b;
    float localX = fract(position.x / 6.0f);
    float barWidth = 0.12f + barcodeGlitchHash(float2(bar, 43.0f)) * 0.42f;
    float ink = 1.0f - step(localX, barWidth) * active * 0.24f;
    float flicker = 0.94f + 0.06f * barcodeGlitchHash(float2(bar + frame, 91.0f));

    return half4(half3(red, shifted.g, blue) * half(ink * flicker), shifted.a);
}
