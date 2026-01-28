//
//  SharpenDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.01.2026.
//

import SwiftUI

struct SharpenDemoView: View {
    @State private var amount = 0.8

    var body: some View {
        ShaderPreviewCard(
            "Sharpen",
            summary: "Boosts local contrast around edges to reveal crisper image detail."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.sharpen(
                        .float(1.5),
                        .float(Float(amount))
                    ),
                    maxSampleOffset: CGSize(width: 2, height: 2)
                )
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1.5)
            }
        }
    }
}
