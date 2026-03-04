//
//  IrisRevealDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.03.2026.
//

import SwiftUI

struct IrisRevealDemoView: View {
    @State private var progress = 0.62

    var body: some View {
        ShaderPreviewCard(
            "Iris Reveal",
            summary: "Opens a soft circular aperture from the center of the image."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.colorEffect(
                        ShaderLibrary.irisReveal(
                            .float2(proxy.size),
                            .float(Float(progress)),
                            .float(10)
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
