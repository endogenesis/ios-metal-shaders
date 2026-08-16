//
//  DisplacementTransitionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.08.2026.
//

import SwiftUI

struct DisplacementTransitionDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Displacement Transition",
            summary: "Pushes the image away through a noisy displacement front."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.displacementTransition(
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
