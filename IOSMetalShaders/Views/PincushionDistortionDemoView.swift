//
//  PincushionDistortionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.05.2026.
//

import SwiftUI

struct PincushionDistortionDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Pincushion Distortion",
            summary: "Bends the image inward with a telephoto lens curve."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.pincushionDistortion(
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
