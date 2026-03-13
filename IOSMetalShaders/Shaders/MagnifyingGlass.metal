//
//  MagnifyingGlass.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.03.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 magnifyingGlass(float2 position, SwiftUI::Layer layer, float2 size, float zoom, float radius) {
    float2 center = size * 0.5f;
    float2 delta = position - center;
    float distanceFromCenter = length(delta);
    float safeZoom = max(zoom, 1.0f);
    float inside = 1.0f - smoothstep(radius - 2.0f, radius, distanceFromCenter);
    float2 sampledPosition = mix(position, center + delta / safeZoom, inside);
    half4 result = layer.sample(sampledPosition);
    float rim = 1.0f - smoothstep(1.2f, 3.0f, abs(distanceFromCenter - radius));
    result.rgb = clamp(result.rgb + half3(half(rim * 0.28f)), half3(0.0h), half3(1.0h));
    return result;
}
