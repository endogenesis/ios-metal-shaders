//
//  PosterizeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.07.2026.
//

import SwiftUI

struct PosterizeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Posterize",
            summary: "Reduces continuous color into bold graphic bands."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.posterize(
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
