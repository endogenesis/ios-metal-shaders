//
//  CanvasTexture.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.03.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 canvasTexture(float2 position, half4 color, float amount) {
    float horizontal = sin(position.y * 2.2f) * 0.55f + sin(position.y * 0.47f) * 0.45f;
    float vertical = sin(position.x * 2.05f + 0.7f) * 0.55f + sin(position.x * 0.41f) * 0.45f;
    float diagonal = sin((position.x + position.y) * 0.17f) * 0.28f;
    float weave = (horizontal + vertical + diagonal) * amount * 0.12f;
    half3 textured = clamp(color.rgb + half3(half(weave)), half3(0.0h), half3(1.0h));
    return half4(textured, color.a);
}
