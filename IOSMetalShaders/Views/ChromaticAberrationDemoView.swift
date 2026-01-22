//
//  ChromaticAberrationDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.01.2026.
//

import SwiftUI

struct ChromaticAberrationDemoView: View {
    @State private var amount = 10.0

    var body: some View {
        ShaderPreviewCard(
            "Chromatic Aberration",
            summary: "Separates red and blue channels toward the edges like an imperfect lens."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.chromaticAberration(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: amount, height: amount)
                    )
                }
        } controls: {
            LabeledContent("Separation") {
                Slider(value: $amount, in: 0...20)
            }
        }
    }
}
