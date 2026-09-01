//
//  CRTPhosphorMask.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.09.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 crtPhosphorMask(float2 position, half4 color, float amount) {
float column = fmod(floor(position.x), 3.0f);
    half3 phosphor = column < 1.0f ? half3(1.0h, 0.42h, 0.42h) : (column < 2.0f ? half3(0.42h, 1.0h, 0.42h) : half3(0.42h, 0.42h, 1.0h));
    half scanline = half(0.72f + 0.28f * sin(position.y * 3.1415926f));
    half3 masked = color.rgb * phosphor * 1.34h * scanline;
    return half4(mix(color.rgb, masked, half(amount)), color.a);
}
