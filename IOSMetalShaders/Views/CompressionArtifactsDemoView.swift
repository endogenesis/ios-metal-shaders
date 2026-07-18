//
//  CompressionArtifactsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.07.2026.
//

import SwiftUI

struct CompressionArtifactsDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Compression Artifacts",
            summary: "Introduces block quantization and ringing from heavy video compression."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.compressionArtifacts(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 96, height: 96)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
