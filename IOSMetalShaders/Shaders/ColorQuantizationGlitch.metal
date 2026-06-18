//
//  ColorQuantizationGlitch.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 colorQuantizationGlitch(float2 position, half4 color, float time, float amount) {
float band = floor(position.y / 13.0f);
    float random = fract(sin(band * 47.13f + floor(time * 10.0f)) * 9182.37f);
    float levels = mix(24.0f, 3.0f, amount * (0.55f + random * 0.45f));
    half3 quantized = floor(color.rgb * half(levels) + 0.5h) / half(levels);
    half3 shifted = random > 0.72f ? half3(quantized.b, quantized.r, quantized.g) : quantized;
    return half4(mix(color.rgb, shifted, half(amount)), color.a);
}
