//
//  PaperGrainDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.04.2026.
//

import SwiftUI

struct PaperGrainDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Paper Grain",
            summary: "Adds fibrous paper texture and a warm matte finish."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.paperGrain(
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
