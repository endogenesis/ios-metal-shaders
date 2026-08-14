//
//  Interlacing.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 interlacing(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float row = floor(position.y);
    float odd = fmod(row, 2.0f);
    float shift = (odd * 2.0f - 1.0f) * amount * 4.0f;
    half4 source = layer.sample(position + float2(shift, 0.0f));
    half line = half(mix(1.0f, odd > 0.5f ? 0.66f : 0.9f, amount));
    source.rgb *= line;
    return source;
}
