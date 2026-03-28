//
//  ShadowsHighlights.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 shadowsHighlights(float2 position, half4 color, float shadows, float highlights) {
    (void)position;
    float luminance = dot(float3(color.rgb), float3(0.2126f, 0.7152f, 0.0722f));
    float shadowMask = pow(1.0f - luminance, 2.0f);
    float highlightMask = pow(luminance, 2.0f);
    float adjustment = shadows * shadowMask + highlights * highlightMask;
    half3 result = clamp(color.rgb + half3(half(adjustment)), half3(0.0h), half3(1.0h));
    return half4(result, color.a);
}
