//
//  LinearWipeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.09.2026.
//

import SwiftUI

struct LinearWipeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Linear Wipe",
            summary: "Reveals the image behind a clean moving linear edge."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.linearWipe(
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
