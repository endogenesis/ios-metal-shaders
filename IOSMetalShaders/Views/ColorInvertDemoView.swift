//
//  ColorInvertDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.03.2026.
//

import SwiftUI

struct ColorInvertDemoView: View {
    @State private var amount = 1.0

    var body: some View {
        ShaderPreviewCard(
            "Color Invert",
            summary: "Blends the original image into its photographic color negative."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.colorInvert(
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
