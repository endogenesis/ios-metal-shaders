//
//  AnalogStatic.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 analogStatic(float2 position, half4 color, float time, float amount) {
float frame = floor(time * 30.0f);
    float noise = fract(sin(dot(position + frame, float2(12.9898f, 78.233f))) * 43758.5453f);
    float roll = sin(position.y * 0.07f - time * 5.0f) * 0.5f + 0.5f;
    half grain = half((noise - 0.5f) * amount * 0.8f + roll * amount * 0.08f);
    half luminance = dot(color.rgb, half3(0.299h, 0.587h, 0.114h));
    half3 analog = half3(luminance + grain);
    return half4(mix(color.rgb, analog, half(amount * 0.78f)), color.a);
}
