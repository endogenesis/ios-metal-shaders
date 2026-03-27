//
//  ColorCurvesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.03.2026.
//

import SwiftUI

struct ColorCurvesDemoView: View {
    @State private var amount = 0.82

    var body: some View {
        ShaderPreviewCard(
            "Color Curves",
            summary: "Applies a smooth S-curve that deepens shadows and lifts highlights."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.colorCurves(
                        .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Curve amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
