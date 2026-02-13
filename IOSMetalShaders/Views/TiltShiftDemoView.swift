//
//  TiltShiftDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.02.2026.
//

import SwiftUI

struct TiltShiftDemoView: View {
    @State private var radius = 7.0

    var body: some View {
        ShaderPreviewCard(
            "Tilt Shift",
            summary: "Keeps a narrow focus band sharp while softening the foreground and distance."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.tiltShift(
                            .float2(proxy.size),
                            .float(Float(radius))
                        ),
                        maxSampleOffset: CGSize(width: radius, height: radius)
                    )
                }
        } controls: {
            LabeledContent("Blur radius") {
                Slider(value: $radius, in: 0...14)
            }
        }
    }
}
