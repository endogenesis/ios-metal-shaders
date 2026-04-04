//
//  ExposureDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.04.2026.
//

import SwiftUI

struct ExposureDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Exposure",
            summary: "Adjusts image exposure in photographic stops."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.exposure(
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
