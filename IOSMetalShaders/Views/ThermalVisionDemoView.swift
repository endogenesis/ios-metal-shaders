//
//  ThermalVisionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.08.2026.
//

import SwiftUI

struct ThermalVisionDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Thermal Vision",
            summary: "Maps luminance onto a vivid heat-camera palette."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.thermalVision(
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
