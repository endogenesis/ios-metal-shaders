//
//  LinearWipe.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.09.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 linearWipe(float2 position, half4 color, float2 size, float amount) {
float progress = position.x / max(size.x, 1.0f);
    float softness = max(0.002f, 10.0f / max(size.x, 1.0f));
    float mask = 1.0f - smoothstep(amount - softness, amount + softness, progress);
    float edge = 1.0f - smoothstep(0.0f, softness * 2.5f, abs(progress - amount));
    half3 highlighted = color.rgb + half3(0.22h, 0.16h, 0.05h) * half(edge);
    return half4(highlighted, color.a * half(mask));
}
