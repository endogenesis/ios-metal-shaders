//
//  PixelateDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.08.2026.
//

import SwiftUI

struct PixelateDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Pixelate",
            summary: "Reduces the image to large adjustable pixels."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.pixelate(
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
