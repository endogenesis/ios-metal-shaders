//
//  SaturationDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.08.2026.
//

import SwiftUI

struct SaturationDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Saturation",
            summary: "Controls color intensity from grayscale to richly saturated."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.saturation(
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
