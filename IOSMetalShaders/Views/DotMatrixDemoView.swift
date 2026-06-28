//
//  DotMatrixDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.06.2026.
//

import SwiftUI

struct DotMatrixDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Dot Matrix",
            summary: "Reconstructs the image with circular display dots."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.dotMatrix(
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
