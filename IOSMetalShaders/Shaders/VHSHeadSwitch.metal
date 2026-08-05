//
//  VHSHeadSwitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 vhsHeadSwitch(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float2 uv = position / max(size, float2(1.0f));
    float boundary = 0.76f + sin(time * 1.3f) * 0.08f;
    float headBand = smoothstep(boundary, boundary + 0.035f, uv.y);
    float bend = sin((uv.y - boundary) * 85.0f - time * 5.0f) * 42.0f * amount * headBand;
    float roll = headBand * amount * 24.0f;
    half4 source = layer.sample(position + float2(bend, -roll));
    source.r = layer.sample(position + float2(bend + 4.0f * amount, -roll)).r;
    return source;
}
