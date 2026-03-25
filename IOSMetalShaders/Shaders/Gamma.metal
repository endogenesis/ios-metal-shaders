//
//  Gamma.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 gamma(float2 position, half4 color, float value) {
    (void)position;
    float safeGamma = max(value, 0.05f);
    half3 corrected = half3(pow(max(float3(color.rgb), float3(0.0f)), float3(1.0f / safeGamma)));
    return half4(corrected, color.a);
}
