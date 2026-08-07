//
//  Pixelate.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.08.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 pixelate(float2 position, SwiftUI::Layer layer, float2 size, float amount) {
float pixelSize = mix(2.0f, 28.0f, amount);
    float2 samplePosition = (floor(position / pixelSize) + 0.5f) * pixelSize;
    return layer.sample(samplePosition);
}
