//
//  WaterCaustics.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.09.2026.
//

#include <metal_stdlib>
using namespace metal;

[[ stitchable ]]
half4 waterCaustics(float2 position, half4 color, float time, float amount) {
float2 p = position * 0.035f;
    float waveA = sin(p.x + sin(p.y * 1.3f + time) * 2.0f + time * 1.4f);
    float waveB = sin(p.y * 1.1f + sin(p.x * 0.8f - time) * 2.2f - time * 1.1f);
    float waveC = sin((p.x + p.y) * 0.72f + time * 0.8f);
    float caustic = pow(max(0.0f, (waveA + waveB + waveC) / 3.0f), 5.0f);
    half3 underwater = color.rgb * half3(0.68h, 0.94h, 1.06h);
    underwater += half3(0.42h, 0.78h, 0.92h) * half(caustic * amount);
    return half4(mix(color.rgb, underwater, half(amount * 0.72f)), color.a);
}
