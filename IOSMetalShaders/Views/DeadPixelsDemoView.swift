//
//  DeadPixelsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.07.2026.
//

import SwiftUI

struct DeadPixelsDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Dead Pixels",
            summary: "Scatters permanently dark pixel clusters across the panel."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.deadPixels(
                            .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
