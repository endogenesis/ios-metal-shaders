//
//  VignetteDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.02.2026.
//

import SwiftUI

struct VignetteDemoView: View {
    @State private var strength = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Vignette",
            summary: "Darkens the frame edges to draw attention toward the center."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.vignette(
                            .float2(proxy.size),
                            .float(Float(strength))
                        )
                    )
                }
        } controls: {
            LabeledContent("Strength") {
                Slider(value: $strength, in: 0...1)
            }
        }
    }
}
