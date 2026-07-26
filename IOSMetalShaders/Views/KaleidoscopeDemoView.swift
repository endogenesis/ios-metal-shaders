//
//  KaleidoscopeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.07.2026.
//

import SwiftUI

struct KaleidoscopeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Kaleidoscope",
            summary: "Folds the image into repeating mirrored wedges."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.kaleidoscope(
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
