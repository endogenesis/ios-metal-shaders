//
//  OutlineDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.08.2026.
//

import SwiftUI

struct OutlineDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Outline",
            summary: "Extracts image contours into a clean graphic outline."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.outline(
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
