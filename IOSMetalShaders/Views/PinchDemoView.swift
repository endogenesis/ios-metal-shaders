//
//  PinchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.06.2026.
//

import SwiftUI

struct PinchDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Pinch",
            summary: "Pulls image detail tightly toward the center."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.pinch(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 120, height: 90)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
