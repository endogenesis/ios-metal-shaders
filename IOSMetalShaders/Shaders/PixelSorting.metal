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

bool pixelSortIsActive(
    half4 color,
    float key,
    constant PixelSortUniforms &uniforms
) {
    return key >= uniforms.thresholdMinimum
        && key <= uniforms.thresholdMaximum
        && color.a > 0.001h;
}

uint2 pixelSortCoordinate(
    uint lineIndex,
    uint position,
    bool isVertical
) {
    return isVertical
        ? uint2(lineIndex, position)
        : uint2(position, lineIndex);
}

// Every thread ranks one pixel inside its contiguous threshold-qualified run,
// then scatters it to its sorted position. Including the original position as
// a tie-breaker gives each source pixel a unique destination. This avoids the
// previous requirement that an entire row or column fit in one threadgroup,
// which caused the renderer to silently skip the effect on some GPUs.
kernel void truePixelSort(
    texture2d<half, access::read> source [[texture(0)]],
    texture2d<half, access::write> destination [[texture(1)]],
    constant PixelSortUniforms &uniforms [[buffer(0)]],
    uint2 position [[thread_position_in_grid]]
) {
    if (position.x >= uniforms.width || position.y >= uniforms.height) {
        return;
    }

    bool isVertical = uniforms.direction == 1u;
    uint lineLength = isVertical ? uniforms.height : uniforms.width;
    uint lineIndex = isVertical ? position.x : position.y;
    uint linePosition = isVertical ? position.y : position.x;
    uint2 coordinate = pixelSortCoordinate(lineIndex, linePosition, isVertical);

    half4 sourceColor = source.read(coordinate);
    float key = pixelSortKey(sourceColor.rgb, uniforms.keyMode);
    if (!pixelSortIsActive(sourceColor, key, uniforms)) {
        destination.write(sourceColor, coordinate);
        return;
    }

    uint runStart = linePosition;
    while (runStart > 0u) {
        uint candidatePosition = runStart - 1u;
        half4 candidate = source.read(
            pixelSortCoordinate(lineIndex, candidatePosition, isVertical)
        );
        float candidateKey = pixelSortKey(candidate.rgb, uniforms.keyMode);
        if (!pixelSortIsActive(candidate, candidateKey, uniforms)) {
            break;
        }
        runStart = candidatePosition;
    }

    uint runEnd = linePosition + 1u;
    while (runEnd < lineLength) {
        half4 candidate = source.read(
            pixelSortCoordinate(lineIndex, runEnd, isVertical)
        );
        float candidateKey = pixelSortKey(candidate.rgb, uniforms.keyMode);
        if (!pixelSortIsActive(candidate, candidateKey, uniforms)) {
            break;
        }
        runEnd += 1u;
    }

    uint rank = 0u;
    for (uint candidatePosition = runStart;
         candidatePosition < runEnd;
         candidatePosition += 1u) {
        half4 candidate = source.read(
            pixelSortCoordinate(lineIndex, candidatePosition, isVertical)
        );
        float candidateKey = pixelSortKey(candidate.rgb, uniforms.keyMode);
        bool hasPriority = uniforms.descending != 0u
            ? candidateKey > key
            : candidateKey < key;
        bool isEarlierTie = candidateKey == key
            && candidatePosition < linePosition;
        rank += hasPriority || isEarlierTie ? 1u : 0u;
    }

    uint2 destinationCoordinate = pixelSortCoordinate(
        lineIndex,
        runStart + rank,
        isVertical
    );
    half amount = half(clamp(uniforms.amount, 0.0f, 1.0f));
    half4 originalDestinationColor = source.read(destinationCoordinate);
    destination.write(
        mix(originalDestinationColor, sourceColor, amount),
        destinationCoordinate
    );
}
