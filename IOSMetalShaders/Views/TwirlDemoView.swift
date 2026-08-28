//
//  TwirlDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.08.2026.
//

import SwiftUI

struct TwirlDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Twirl",
            summary: "Twists the center of the image into a smooth spiral."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.twirl(
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
