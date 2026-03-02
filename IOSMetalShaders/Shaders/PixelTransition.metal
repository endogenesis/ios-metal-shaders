//
//  PixelTransition.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.03.2026.
//

#include <metal_stdlib>
using namespace metal;

float pixelTransitionHash(float2 value) {
    return fract(sin(dot(value, float2(91.7f, 283.3f))) * 43758.5453f);
}

[[ stitchable ]]
half4 pixelTransition(float2 position, half4 color, float2 size, float progress, float pixelSize) {
    (void)size;
    float2 block = floor(position / max(pixelSize, 2.0f));
    float threshold = pixelTransitionHash(block);
    float mask = step(threshold, clamp(progress, 0.0f, 1.0f));
    half3 stepped = floor(color.rgb * 8.0h + 0.5h) / 8.0h;
    half edge = half(1.0f - smoothstep(0.0f, 0.08f, abs(progress - threshold)));
    half3 result = mix(stepped, half3(1.0h), edge * 0.18h);
    return half4(result, color.a * half(mask));
}
