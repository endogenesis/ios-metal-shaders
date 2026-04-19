//
//  MosaicDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.04.2026.
//

import SwiftUI

struct MosaicDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Mosaic",
            summary: "Rebuilds the image from adjustable square tiles."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.mosaic(
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
