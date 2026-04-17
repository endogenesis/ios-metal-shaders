//
//  AuroraGradient.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 auroraGradient(float2 position, half4 color, float time, float amount) {
float ribbon = sin(position.x * 0.018f + time * 0.8f + sin(position.y * 0.012f - time) * 2.0f);
    float curtain = smoothstep(0.0f, 1.0f, ribbon * 0.5f + 0.5f);
    float shimmer = sin(position.y * 0.045f + time * 2.2f) * 0.5f + 0.5f;
    half3 aurora = mix(half3(0.04h, 0.16h, 0.34h), half3(0.12h, 0.95h, 0.58h), half(curtain));
    aurora = mix(aurora, half3(0.62h, 0.2h, 0.92h), half(shimmer * curtain * 0.55f));
    return half4(mix(color.rgb, aurora, half(amount * 0.78f)), color.a);
}
