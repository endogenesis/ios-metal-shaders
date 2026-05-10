//
//  RadialBlur.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 10.05.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 radialBlur(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float2 center = size * 0.5f;
    float2 direction = (center - position) * amount * 0.045f;
    half4 sum = half4(0.0h);
    for (int index = -4; index <= 4; ++index) {
        sum += layer.sample(position + direction * float(index));
    }
    return sum / 9.0h;
}
