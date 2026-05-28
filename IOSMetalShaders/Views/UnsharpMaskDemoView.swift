//
//  UnsharpMaskDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.05.2026.
//

import SwiftUI

struct UnsharpMaskDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Unsharp Mask",
            summary: "Sharpens local detail by subtracting a soft blur."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.unsharpMask(
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
