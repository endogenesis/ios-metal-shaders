//
//  SoftGlowDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.05.2026.
//

import SwiftUI

struct SoftGlowDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Soft Glow",
            summary: "Wraps the image in a gentle diffused glow."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.softGlow(
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
