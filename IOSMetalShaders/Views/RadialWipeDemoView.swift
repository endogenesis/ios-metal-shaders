//
//  RadialWipeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.07.2026.
//

import SwiftUI

struct RadialWipeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Radial Wipe",
            summary: "Reveals the image with a rotating radial sweep."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.radialWipe(
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
