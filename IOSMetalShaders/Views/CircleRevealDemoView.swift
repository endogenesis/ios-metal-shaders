//
//  CircleRevealDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.06.2026.
//

import SwiftUI

struct CircleRevealDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Circle Reveal",
            summary: "Reveals the image through an expanding circular mask."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.circleReveal(
                            .float2(proxy.size),
                            .float(Float(amount))
                        )
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
