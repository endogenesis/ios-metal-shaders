//
//  DeadPixels.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.07.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 deadPixels(float2 position, half4 color, float amount) {
float2 pixel = floor(position / 2.5f);
    float random = fract(sin(dot(pixel, float2(31.7f, 91.3f))) * 43758.5453f);
    float neighbor = fract(sin(dot(floor(pixel / 2.0f), float2(17.1f, 63.9f))) * 12731.17f);
    float dead = step(0.997f - amount * 0.025f, max(random, neighbor));
    return half4(mix(color.rgb, half3(0.005h), half(dead)), color.a);
}
