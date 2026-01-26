//
//  PixelSorting.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

float pixelSortingLuminance(half3 color) {
    return dot(float3(color), float3(0.2126f, 0.7152f, 0.0722f));
}

[[ stitchable ]]
half4 pixelSorting(float2 position, SwiftUI::Layer layer, float radius) {
    half4 source = layer.sample(position);
    half3 darkest = source.rgb;
    half3 brightest = source.rgb;
    float minimumLuminance = pixelSortingLuminance(source.rgb);
    float maximumLuminance = minimumLuminance;

    for (int index = -6; index <= 6; index++) {
        float offset = float(index) * radius / 6.0f;
        half3 sampleColor = layer.sample(position + float2(offset, 0.0f)).rgb;
        float luminance = pixelSortingLuminance(sampleColor);
        if (luminance < minimumLuminance) {
            minimumLuminance = luminance;
            darkest = sampleColor;
        }
        if (luminance > maximumLuminance) {
            maximumLuminance = luminance;
            brightest = sampleColor;
        }
    }

    float stripe = step(0.5f, fract(position.y / 22.0f));
    half3 sorted = mix(darkest, brightest, half(stripe));
    half gate = half(smoothstep(0.08f, 0.45f, maximumLuminance - minimumLuminance));
    return half4(mix(source.rgb, sorted, gate * 0.82h), source.a);
}
