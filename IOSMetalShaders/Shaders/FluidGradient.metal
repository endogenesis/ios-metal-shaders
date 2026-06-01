//
//  FluidGradient.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 fluidGradient(float2 position, half4 color, float time, float amount) {
float x = position.x * 0.012f;
    float y = position.y * 0.014f;
    float flowA = sin(x + time) * cos(y - time * 0.7f) * 0.5f + 0.5f;
    float flowB = sin(x * 0.7f - y * 1.2f + time * 0.6f) * 0.5f + 0.5f;
    half3 first = mix(half3(0.08h, 0.25h, 0.7h), half3(0.98h, 0.28h, 0.48h), half(flowA));
    half3 fluid = mix(first, half3(0.95h, 0.72h, 0.16h), half(flowB * 0.65f));
    return half4(mix(color.rgb, fluid, half(amount * 0.72f)), color.a);
}
