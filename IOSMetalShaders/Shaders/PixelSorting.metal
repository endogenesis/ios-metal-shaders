//
//  PixelSorting.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.01.2026.
//

#include <metal_stdlib>
using namespace metal;

struct PixelSortUniforms {
    uint width;
    uint height;
    uint direction;
    uint keyMode;
    float thresholdMinimum;
    float thresholdMaximum;
    float amount;
    uint descending;
};

struct PixelSortItem {
    half4 color;
    float key;
    uint isActive;
};

float pixelSortLuminance(half3 color) {
    return dot(float3(color), float3(0.2126f, 0.7152f, 0.0722f));
}

float pixelSortSaturation(half3 color) {
    float3 rgb = float3(color);
    float maximum = max(rgb.r, max(rgb.g, rgb.b));
    float minimum = min(rgb.r, min(rgb.g, rgb.b));
    return maximum > 0.0001f ? (maximum - minimum) / maximum : 0.0f;
}

float pixelSortHue(half3 color) {
    float3 rgb = float3(color);
    float maximum = max(rgb.r, max(rgb.g, rgb.b));
    float minimum = min(rgb.r, min(rgb.g, rgb.b));
    float delta = maximum - minimum;

    if (delta < 0.0001f) {
        return 0.0f;
    }

    float hue;
    if (maximum == rgb.r) {
        hue = (rgb.g - rgb.b) / delta;
    } else if (maximum == rgb.g) {
        hue = 2.0f + (rgb.b - rgb.r) / delta;
    } else {
        hue = 4.0f + (rgb.r - rgb.g) / delta;
    }

    return fract(hue / 6.0f);
}

float pixelSortKey(half3 color, uint keyMode) {
    if (keyMode == 1u) {
        return pixelSortHue(color);
    }
    if (keyMode == 2u) {
        return pixelSortSaturation(color);
    }
    return pixelSortLuminance(color);
}

// Each threadgroup owns one complete row or column. All pixels are first loaded
// into threadgroup memory, then an odd-even transposition network sorts every
// contiguous threshold-qualified run without allowing pixels to cross inactive
// boundaries. Unlike a fragment approximation, this performs real compare/swap
// operations and writes the reordered colors back to the output texture.
kernel void truePixelSort(
    texture2d<half, access::read> source [[texture(0)]],
    texture2d<half, access::write> destination [[texture(1)]],
    constant PixelSortUniforms &uniforms [[buffer(0)]],
    threadgroup PixelSortItem *items [[threadgroup(0)]],
    uint threadIndex [[thread_index_in_threadgroup]],
    uint3 groupPosition [[threadgroup_position_in_grid]]
) {
    bool isVertical = uniforms.direction == 1u;
    uint lineLength = isVertical ? uniforms.height : uniforms.width;
    uint lineIndex = groupPosition.x;

    if (threadIndex >= lineLength) {
        return;
    }

    uint2 coordinate = isVertical
        ? uint2(lineIndex, threadIndex)
        : uint2(threadIndex, lineIndex);

    half4 sourceColor = source.read(coordinate);
    float key = pixelSortKey(sourceColor.rgb, uniforms.keyMode);
    bool isActive = key >= uniforms.thresholdMinimum
        && key <= uniforms.thresholdMaximum
        && sourceColor.a > 0.001h;

    items[threadIndex].color = sourceColor;
    items[threadIndex].key = key;
    items[threadIndex].isActive = isActive ? 1u : 0u;

    threadgroup_barrier(mem_flags::mem_threadgroup);

    // Odd and even phases alternate adjacent compare/swap pairs. Inactive
    // pixels behave as hard barriers, so separate brightness runs are sorted
    // independently while keeping the rest of the image fixed in place.
    for (uint phase = 0u; phase < lineLength; phase++) {
        uint leftIndex = threadIndex * 2u + (phase & 1u);
        uint rightIndex = leftIndex + 1u;

        if (rightIndex < lineLength) {
            PixelSortItem left = items[leftIndex];
            PixelSortItem right = items[rightIndex];

            if (left.isActive != 0u && right.isActive != 0u) {
                bool shouldSwap = uniforms.descending != 0u
                    ? left.key < right.key
                    : left.key > right.key;

                if (shouldSwap) {
                    items[leftIndex] = right;
                    items[rightIndex] = left;
                }
            }
        }

        threadgroup_barrier(mem_flags::mem_threadgroup);
    }

    half amount = half(clamp(uniforms.amount, 0.0f, 1.0f));
    half4 sortedColor = items[threadIndex].color;
    destination.write(mix(sourceColor, sortedColor, amount), coordinate);
}
