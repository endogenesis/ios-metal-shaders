//
//  Shaders.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 grayscale(float2 position, half4 color, float amount) {
    (void)position;

    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half safeAmount = half(clamp(amount, 0.0f, 1.0f));
    half3 result = mix(color.rgb, half3(luminance), safeAmount);

    return half4(result, color.a);
}

[[ stitchable ]]
half4 scanlines(float2 position, half4 color, float time, float intensity) {
    float phase = position.y * 0.18f + time * 5.0f;
    float stripe = 0.5f + 0.5f * sin(phase);
    float safeIntensity = clamp(intensity, 0.0f, 0.8f);
    half brightness = half(1.0f - stripe * safeIntensity);

    return half4(color.rgb * brightness, color.a);
}

[[ stitchable ]]
float2 wave(float2 position, float time, float amplitude, float wavelength) {
    float safeWavelength = max(wavelength, 1.0f);
    float offset = sin(position.x / safeWavelength + time * 3.0f) * amplitude;

    return float2(position.x, position.y + offset);
}
