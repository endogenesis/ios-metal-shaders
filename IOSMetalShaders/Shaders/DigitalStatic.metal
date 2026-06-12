//
//  DigitalStatic.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 digitalStatic(float2 position, half4 color, float time, float amount) {
float frame = floor(time * 24.0f);
    float noise = fract(sin(dot(floor(position), float2(12.9898f, 78.233f)) + frame * 9.17f) * 43758.5453f);
    float burst = step(0.62f + (1.0f - amount) * 0.3f, noise);
    half staticValue = half(step(0.5f, noise));
    half3 damaged = mix(color.rgb, half3(staticValue), half(burst * amount));
    return half4(damaged, color.a);
}
