//
//  ZoomBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.03.2026.
//

import SwiftUI

struct ZoomBlurDemoView: View {
    @State private var amount = 20.0

    var body: some View {
        ShaderPreviewCard(
            "Zoom Blur",
            summary: "Stretches samples radially toward the center for a rapid zoom impression."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.zoomBlur(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: amount, height: amount)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...36)
            }
        }
    }
}
