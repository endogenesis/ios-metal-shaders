//
//  DoubleVisionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.07.2026.
//

import SwiftUI

struct DoubleVisionDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Double Vision",
            summary: "Overlaps two offset views into a disorienting duplicate image."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.doubleVision(
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
