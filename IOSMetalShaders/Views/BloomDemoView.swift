//
//  BloomDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.04.2026.
//

import SwiftUI

struct BloomDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Bloom",
            summary: "Spreads bright highlights into a soft luminous bloom."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.bloom(
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
