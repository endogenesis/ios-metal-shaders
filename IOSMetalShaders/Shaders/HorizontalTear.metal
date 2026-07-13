//
//  HorizontalTear.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 horizontalTear(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float band = floor(position.y / 15.0f);
    float frame = floor(time * 9.0f);
    float random = fract(sin(band * 53.17f + frame * 7.31f) * 43758.5453f);
    float active = step(0.73f - amount * 0.2f, random);
    float shift = (random - 0.5f) * 110.0f * amount * active;
    half4 torn = layer.sample(position + float2(shift, 0.0f));
    torn.r = layer.sample(position + float2(shift * 1.08f, 0.0f)).r;
    return torn;
}
