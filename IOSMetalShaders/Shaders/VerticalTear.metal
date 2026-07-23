//
//  VerticalTear.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 verticalTear(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float column = floor(position.x / 17.0f);
    float frame = floor(time * 8.0f);
    float random = fract(sin(column * 71.19f + frame * 5.73f) * 43758.5453f);
    float active = step(0.75f - amount * 0.18f, random);
    float shift = (random - 0.5f) * 90.0f * amount * active;
    half4 torn = layer.sample(position + float2(0.0f, shift));
    torn.b = layer.sample(position - float2(0.0f, shift * 0.35f)).b;
    return torn;
}
