//
//  SolarizeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.03.2026.
//

import SwiftUI

struct SolarizeDemoView: View {
    @State private var threshold = 0.52

    var body: some View {
        ShaderPreviewCard(
            "Solarize",
            summary: "Inverts channels above a threshold for a photographic solarization effect."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.solarize(
                        .float(Float(threshold)),
                        .float(1)
                    )
                )
        } controls: {
            LabeledContent("Threshold") {
                Slider(value: $threshold, in: 0...1)
            }
        }
    }
}
