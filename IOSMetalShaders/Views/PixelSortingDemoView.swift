//
//  PixelSortingDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.01.2026.
//

import SwiftUI

struct PixelSortingDemoView: View {
    @State private var radius = 9.0

    var body: some View {
        ShaderPreviewCard(
            "Pixel Sorting",
            summary: "Pulls local light and dark pixels into alternating horizontal streaks."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.pixelSorting(
                        .float(Float(radius))
                    ),
                    maxSampleOffset: CGSize(width: radius, height: 0)
                )
        } controls: {
            LabeledContent("Sort radius") {
                Slider(value: $radius, in: 1...16)
            }
        }
    }
}
