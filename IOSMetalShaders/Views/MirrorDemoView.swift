//
//  MirrorDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.08.2026.
//

import SwiftUI

struct MirrorDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Mirror",
            summary: "Reflects the frame inward from both sides."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.mirror(
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
