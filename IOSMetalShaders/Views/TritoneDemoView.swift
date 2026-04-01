//
//  TritoneDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

struct TritoneDemoView: View {
    @State private var amount = 1.0

    var body: some View {
        ShaderPreviewCard(
            "Tritone",
            summary: "Maps shadows, midtones, and highlights to a three-color cinematic palette."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.tritone(
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
