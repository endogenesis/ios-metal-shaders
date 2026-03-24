//
//  TintDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.03.2026.
//

import SwiftUI

struct TintDemoView: View {
    @State private var amount = 0.55

    var body: some View {
        ShaderPreviewCard(
            "Tint",
            summary: "Blends a cool teal tint into the source while retaining tonal detail."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.tint(
                        .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Tint amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
