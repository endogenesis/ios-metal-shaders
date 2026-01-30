//
//  Duotone.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.01.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 duotone(float2 position, half4 color, float amount) {
    (void)position;
    half luminance = dot(color.rgb, half3(0.2126h, 0.7152h, 0.0722h));
    half3 shadows = half3(0.055h, 0.035h, 0.19h);
    half3 highlights = half3(1.0h, 0.68h, 0.16h);
    half3 mapped = mix(shadows, highlights, smoothstep(0.05h, 0.95h, luminance));
    return half4(mix(color.rgb, mapped, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
