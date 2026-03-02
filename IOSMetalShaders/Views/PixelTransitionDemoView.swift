//
//  PixelTransitionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.03.2026.
//

import SwiftUI

struct PixelTransitionDemoView: View {
    @State private var progress = 0.58

    var body: some View {
        ShaderPreviewCard(
            "Pixel Transition",
            summary: "Reveals the image in randomized pixel blocks across the frame."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.pixelTransition(
                            .float2(proxy.size),
                            .float(Float(progress)),
                            .float(12)
                        )
                    )
                }
        } controls: {
            LabeledContent("Progress") {
                Slider(value: $progress, in: 0...1)
            }
        }
    }
}
