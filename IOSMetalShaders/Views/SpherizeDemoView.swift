//
//  SpherizeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.03.2026.
//

import SwiftUI

struct SpherizeDemoView: View {
    @State private var strength = 0.78

    var body: some View {
        ShaderPreviewCard(
            "Spherize",
            summary: "Wraps the image across a rounded glass-sphere projection."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.spherize(
                            .float2(proxy.size),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: 52, height: 52)
                    )
                }
        } controls: {
            LabeledContent("Strength") {
                Slider(value: $strength, in: 0...1)
            }
        }
    }
}
