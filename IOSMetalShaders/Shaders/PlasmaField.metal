//
//  PlasmaField.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.04.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 plasmaField(float2 position, half4 color, float time, float amount) {
float field = sin(position.x * 0.025f + time * 1.7f);
    field += sin(position.y * 0.031f - time * 1.2f);
    field += sin((position.x + position.y) * 0.018f + time * 0.8f);
    field = sin(field * 2.2f + time) * 0.5f + 0.5f;
    half3 plasma = mix(half3(0.08h, 0.02h, 0.28h), half3(0.1h, 0.9h, 0.95h), half(field));
    plasma = mix(plasma, half3(1.0h, 0.12h, 0.55h), half(smoothstep(0.58f, 1.0f, field)));
    return half4(mix(color.rgb, plasma, half(amount * 0.86f)), color.a);
}
