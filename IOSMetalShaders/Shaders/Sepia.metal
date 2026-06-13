//
//  Sepia.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.06.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 sepia(float2 position, half4 color, float amount) {
(void)position;
    half3 sepiaColor = half3(
        dot(color.rgb, half3(0.393h, 0.769h, 0.189h)),
        dot(color.rgb, half3(0.349h, 0.686h, 0.168h)),
        dot(color.rgb, half3(0.272h, 0.534h, 0.131h))
    );
    return half4(mix(color.rgb, clamp(sepiaColor, half3(0.0h), half3(1.0h)), half(amount)), color.a);
}
