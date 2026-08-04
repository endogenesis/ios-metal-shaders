//
//  ToonShadeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.08.2026.
//

import SwiftUI

struct ToonShadeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Toon Shade",
            summary: "Flattens color and inks edges like cel animation."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.toonShade(
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
