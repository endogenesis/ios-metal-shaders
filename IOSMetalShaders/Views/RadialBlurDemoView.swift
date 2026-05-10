//
//  RadialBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 10.05.2026.
//

import SwiftUI

struct RadialBlurDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Radial Blur",
            summary: "Streaks pixels outward from the image center."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.radialBlur(
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
