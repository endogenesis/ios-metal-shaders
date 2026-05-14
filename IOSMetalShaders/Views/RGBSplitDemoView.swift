//
//  RGBSplitDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.05.2026.
//

import SwiftUI

struct RGBSplitDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "RGB Split",
            summary: "Separates red, green, and blue into offset trails."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.rgbSplit(
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
