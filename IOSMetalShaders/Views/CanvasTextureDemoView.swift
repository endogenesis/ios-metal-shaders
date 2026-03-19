//
//  CanvasTextureDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.03.2026.
//

import SwiftUI

struct CanvasTextureDemoView: View {
    @State private var amount = 0.38

    var body: some View {
        ShaderPreviewCard(
            "Canvas Texture",
            summary: "Embosses crossing fiber ridges to imitate a woven artist canvas."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.canvasTexture(
                        .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Texture") {
                Slider(value: $amount, in: 0...0.75)
            }
        }
    }
}
