//
//  StuckPixels.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 stuckPixels(float2 position, half4 color, float time, float amount) {
float2 pixel = floor(position / 3.0f);
    float random = fract(sin(dot(pixel, float2(39.346f, 11.135f))) * 3571.924f);
    float blink = step(0.4f, fract(random * 13.0f + floor(time * 2.0f) * 0.07f));
    float active = step(0.995f - amount * 0.02f, random) * blink;
    half3 stuckColor = half3(step(0.5f, fract(random * 7.0f)), step(0.5f, fract(random * 11.0f)), step(0.5f, fract(random * 17.0f)));
    return half4(mix(color.rgb, stuckColor, half(active)), color.a);
}
