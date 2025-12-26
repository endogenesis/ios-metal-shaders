//
//  GrayscaleDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct GrayscaleDemoView: View {
    @State private var intensity = 0.8

    var body: some View {
        ShaderPreviewCard(
            "Grayscale",
            summary: "Mixes every source pixel with its luminance value."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.grayscale(
                        .float(Float(intensity))
                    )
                )
        } controls: {
            LabeledContent("Intensity") {
                Slider(value: $intensity, in: 0...1)
                    .accessibilityLabel("Grayscale intensity")
                    .accessibilityValue(
                        Text(intensity, format: .percent.precision(.fractionLength(0)))
                    )
            }
        }
    }
}
