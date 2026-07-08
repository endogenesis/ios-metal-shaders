//
//  Ghosting.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.07.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 ghosting(float2 position, SwiftUI::Layer layer, float2 size, float time, float amount) {
float drift = (8.0f + amount * 24.0f) * (0.7f + 0.3f * sin(time * 1.7f));
    half4 source = layer.sample(position);
    half4 first = layer.sample(position - float2(drift, 0.0f));
    half4 second = layer.sample(position - float2(drift * 2.15f, sin(time) * 3.0f));
    half3 echo = first.rgb * 0.34h + second.rgb * 0.17h;
    return half4(mix(source.rgb, source.rgb + echo, half(amount * 0.72f)), source.a);
}
