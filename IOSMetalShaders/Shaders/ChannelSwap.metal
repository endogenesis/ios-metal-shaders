//
//  ChannelSwap.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.02.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 channelSwap(float2 position, half4 color, float amount) {
    (void)position;
    half3 swapped = color.gbr;
    return half4(mix(color.rgb, swapped, half(clamp(amount, 0.0f, 1.0f))), color.a);
}
