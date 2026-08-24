//
//  BitCrushDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.08.2026.
//

import SwiftUI

struct BitCrushDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Bit Crush",
            summary: "Crushes color precision into hard retro steps."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.bitCrush(
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
