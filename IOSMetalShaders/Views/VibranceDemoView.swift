//
//  VibranceDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.08.2026.
//

import SwiftUI

struct VibranceDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Vibrance",
            summary: "Boosts muted colors while protecting already vivid tones."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.vibrance(
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
