//
//  SliceGlitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 sliceGlitch(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float slice = floor(position.y / mix(5.0f, 19.0f, amount));
    float frame = floor(time * 10.0f);
    float random = fract(sin(slice * 83.19f + frame * 2.17f) * 43758.5453f);
    float direction = fmod(slice, 2.0f) < 1.0f ? -1.0f : 1.0f;
    float shift = direction * random * amount * 54.0f * step(0.48f, random);
    half4 sliced = layer.sample(position + float2(shift, 0.0f));
    sliced.g = layer.sample(position - float2(shift * 0.18f, 0.0f)).g;
    return sliced;
}
