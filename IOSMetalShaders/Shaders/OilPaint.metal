//
//  OilPaint.metal
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.01.2026.
//

#include <metal_stdlib>
#include <SwiftUI/SwiftUI_Metal.h>
using namespace metal;

[[ stitchable ]]
half4 oilPaint(float2 position, SwiftUI::Layer layer, float radius) {
    int sampleRadius = clamp(int(round(radius)), 1, 6);
    half3 regionMeans[4];
    float regionVariances[4];

    for (int region = 0; region < 4; region++) {
        int xStart = (region & 1) == 0 ? -sampleRadius : 0;
        int xEnd = (region & 1) == 0 ? 0 : sampleRadius;
        int yStart = (region & 2) == 0 ? -sampleRadius : 0;
        int yEnd = (region & 2) == 0 ? 0 : sampleRadius;

        half3 colorSum = half3(0.0h);
        half3 squaredColorSum = half3(0.0h);
        float sampleCount = 0.0f;

        for (int y = yStart; y <= yEnd; y++) {
            for (int x = xStart; x <= xEnd; x++) {
                half3 sampleColor = layer.sample(
                    position + float2(float(x), float(y))
                ).rgb;
                colorSum += sampleColor;
                squaredColorSum += sampleColor * sampleColor;
                sampleCount += 1.0f;
            }
        }

        half inverseCount = half(1.0f / sampleCount);
        half3 mean = colorSum * inverseCount;
        half3 variance = abs(squaredColorSum * inverseCount - mean * mean);

        regionMeans[region] = mean;
        regionVariances[region] = float(variance.r + variance.g + variance.b);
    }

    int smoothestRegion = 0;
    for (int region = 1; region < 4; region++) {
        if (regionVariances[region] < regionVariances[smoothestRegion]) {
            smoothestRegion = region;
        }
    }

    half alpha = layer.sample(position).a;
    return half4(regionMeans[smoothestRegion], alpha);
}
