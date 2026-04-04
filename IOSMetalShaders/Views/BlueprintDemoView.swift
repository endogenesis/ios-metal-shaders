//
//  BlueprintDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.04.2026.
//

import SwiftUI

struct BlueprintDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Blueprint",
            summary: "Turns contours into crisp technical drawing lines."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.blueprint(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 72, height: 72)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
