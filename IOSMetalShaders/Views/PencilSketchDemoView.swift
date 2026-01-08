//
//  PencilSketchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.01.2026.
//

import SwiftUI

struct PencilSketchDemoView: View {
    @State private var strength = 1.4

    var body: some View {
        ShaderPreviewCard(
            "Pencil Sketch",
            summary: "Draws luminance edges as graphite-like strokes on a pale surface."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.pencilSketch(
                        .float(Float(strength))
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
        } controls: {
            LabeledContent("Stroke strength") {
                Slider(value: $strength, in: 0.5...2.5)
                    .accessibilityLabel("Pencil stroke strength")
                    .accessibilityValue(Text(strength, format: .number.precision(.fractionLength(1))))
            }
        }
    }
}
