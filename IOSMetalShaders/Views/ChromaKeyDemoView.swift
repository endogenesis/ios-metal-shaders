//
//  ChromaKeyDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.07.2026.
//

import SwiftUI

struct ChromaKeyDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Chroma Key",
            summary: "Keys green hues into transparency with a soft spill edge."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.chromaKey(
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
