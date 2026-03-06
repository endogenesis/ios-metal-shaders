//
//  Ripple.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 06.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
float2 ripple(float2 position, float2 size, float time, float amplitude, float wavelength) {
    float2 delta = position - size * 0.5f;
    float distanceFromCenter = length(delta);
    float2 direction = delta / max(distanceFromCenter, 1.0f);
    float safeWavelength = max(wavelength, 2.0f);
    float wave = sin(distanceFromCenter / safeWavelength * 6.2831853f - time * 4.0f);
    float fade = exp(-distanceFromCenter / max(length(size), 1.0f));
    return position + direction * wave * amplitude * fade;
}
