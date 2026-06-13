//
//  SepiaDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.06.2026.
//

import SwiftUI

struct SepiaDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Sepia",
            summary: "Warms the image with a classic sepia photograph tone."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.sepia(
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
