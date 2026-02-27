//
//  BayerDitherDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.02.2026.
//

import SwiftUI

struct BayerDitherDemoView: View {
    @State private var levels = 5.0

    var body: some View {
        ShaderPreviewCard(
            "Bayer Dither",
            summary: "Quantizes color through an ordered 4-by-4 Bayer threshold matrix."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.bayerDither(
                        .float(Float(levels))
                    )
                )
        } controls: {
            LabeledContent("Color levels") {
                Slider(value: $levels, in: 2...10, step: 1)
            }
        }
    }
}
