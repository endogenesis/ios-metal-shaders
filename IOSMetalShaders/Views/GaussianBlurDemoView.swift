//
//  GaussianBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.04.2026.
//

import SwiftUI

struct GaussianBlurDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Gaussian Blur",
            summary: "Softens detail with a balanced Gaussian kernel."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.gaussianBlur(
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
