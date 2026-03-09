//
//  DirectionalBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.03.2026.
//

import SwiftUI

struct DirectionalBlurDemoView: View {
    @State private var radius = 10.0
    @State private var angle = 24.0

    var body: some View {
        ShaderPreviewCard(
            "Directional Blur",
            summary: "Smears pixels along a controllable angle for a linear motion effect."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.directionalBlur(
                        .float(Float(radius)),
                        .float(Float(angle * .pi / 180))
                    ),
                    maxSampleOffset: CGSize(width: radius, height: radius)
                )
        } controls: {
            VStack {
                LabeledContent("Radius") {
                    Slider(value: $radius, in: 0...18)
                }

                LabeledContent("Angle") {
                    Slider(value: $angle, in: 0...180)
                }
            }
        }
    }
}
