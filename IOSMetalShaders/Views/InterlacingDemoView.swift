//
//  InterlacingDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.08.2026.
//

import SwiftUI

struct InterlacingDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Interlacing",
            summary: "Separates alternating video fields into visible interlaced lines."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.interlacing(
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
