//
//  DustDissolve.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.11.2026.
//
//  Adapted from ismnoiet/repgem-catalog, packages/ios/dust-dissolve-ios:
//  https://github.com/ismnoiet/repgem-catalog/blob/main/packages/ios/dust-dissolve-ios/Sources/DustDissolve/Shaders/DustDissolve.metal
//
//  MIT License
//
//  Copyright (c) 2026 ismnoiet
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#include <metal_stdlib>
using namespace metal;

// 0: left to right, 1: right to left, 2: top to bottom, 3: bottom to top, 4: center out.
static float dustDissolveField(float2 uv, int direction) {
    float x = uv.x;
    float y = uv.y;
    if (direction == 1) {
        x = 1.0f - uv.x;
    } else if (direction == 2) {
        x = uv.y;
        y = uv.x;
    } else if (direction == 3) {
        x = 1.0f - uv.y;
        y = uv.x;
    } else if (direction == 4) {
        x = min(length(uv - 0.5f) * 1.4f, 1.0f);
        y = uv.x + uv.y;
    }

    float waves = sin(x * 17.0f + y * 6.0f) * 0.5f
        + sin(x * 7.0f - y * 13.0f + 1.7f) * 0.35f
        + sin(y * 21.0f + x * 3.0f + 0.6f) * 0.25f;
    return x * 0.82f + (waves * 0.5f + 0.5f) * 0.22f;
}

static float dustDissolveHash(float2 position) {
    position = fract(position * float2(123.34f, 456.21f));
    position += dot(position, position + 45.32f);
    return fract(position.x * position.y);
}

[[ stitchable ]]
half4 dustDissolve(
    float2 position,
    half4 color,
    float2 size,
    float progress,
    float shimmer,
    float direction,
    float grainSize
) {
    if (progress >= 1.0f) {
        return half4(0.0h);
    }

    if (shimmer > 0.0f && shimmer < 1.0f) {
        float sweep = smoothstep(0.0f, 1.0f, shimmer);
        float diagonal = position.x + position.y * 0.32f;
        float span = size.x + size.y * 0.32f + 80.0f;
        float center = -40.0f + span * sweep;
        float distance = (diagonal - center) / 14.0f;
        float band = exp(-distance * distance);
        color.rgb = min(color.rgb + half3(half(band * 0.55f)) * color.a, half3(color.a));
    }

    if (progress <= 0.0f) {
        return color;
    }

    float2 uv = position / max(size, float2(1.0f));
    float field = dustDissolveField(uv, int(direction + 0.5f));
    float threshold = -0.06f + 1.2f * progress;
    float noise = dustDissolveHash(floor(position / max(grainSize, 0.5f)));
    float distance = field - threshold + 0.05f;

    // A binary mask keeps the source colors intact as the edge breaks into grains.
    float visible = step(noise * 0.10f, distance);
    float rim = visible * (1.0f - smoothstep(0.0f, 0.05f, distance));
    half3 glow = half3(0.93h, 0.88h, 1.0h) * color.a;
    half3 rgb = mix(color.rgb, glow, half(rim * 0.45f));
    return half4(rgb, color.a) * half(visible);
}
