//
//  HalftoneDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.02.2026.
//

import SwiftUI

struct HalftoneDemoView: View {
    @State private var scale = 8.0

    var body: some View {
        ShaderPreviewCard(
            "Halftone",
            summary: "Rebuilds tones from a regular grid of variable-size printed dots."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.halftone(
                        .float(Float(scale)),
                        .float(0.9)
                    )
                )
        } controls: {
            LabeledContent("Dot size") {
                Slider(value: $scale, in: 4...16)
            }
        }
    }
}
