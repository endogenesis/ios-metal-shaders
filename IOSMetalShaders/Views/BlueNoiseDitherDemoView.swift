//
//  BlueNoiseDitherDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.03.2026.
//

import SwiftUI

struct BlueNoiseDitherDemoView: View {
    @State private var amount = 0.82

    var body: some View {
        ShaderPreviewCard(
            "Blue Noise Dither",
            summary: "Uses decorrelated spatial noise to hide color quantization bands."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.blueNoiseDither(
                        .float(Float(amount)),
                        .float(6)
                    )
                )
        } controls: {
            LabeledContent("Dither amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
