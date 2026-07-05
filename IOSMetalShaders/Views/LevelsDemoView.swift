//
//  LevelsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.07.2026.
//

import SwiftUI

struct LevelsDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Levels",
            summary: "Remaps black, midpoint, and white levels for cleaner tonal range."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.levels(
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
