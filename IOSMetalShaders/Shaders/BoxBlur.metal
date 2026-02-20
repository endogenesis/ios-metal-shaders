//
//  BoxBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.02.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 boxBlur(float2 position, SwiftUI::Layer layer, float radius) {
    half4 source = layer.sample(position);
    half3 sum = half3(0.0h);
    for (int y = -2; y <= 2; y++) {
        for (int x = -2; x <= 2; x++) {
            float2 offset = float2(float(x), float(y)) * radius * 0.5f;
            sum += layer.sample(position + offset).rgb;
        }
    }
    return half4(sum / 25.0h, source.a);
}
