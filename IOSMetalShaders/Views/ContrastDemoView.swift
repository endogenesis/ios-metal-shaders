//
//  ContrastDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.05.2026.
//

import SwiftUI

struct ContrastDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Contrast",
            summary: "Expands or compresses tonal contrast around mid-gray."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.contrast(
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
