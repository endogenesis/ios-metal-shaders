//
//  EmbossDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.05.2026.
//

import SwiftUI

struct EmbossDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Emboss",
            summary: "Raises image detail into metallic relief."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.emboss(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 72, height: 72)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
