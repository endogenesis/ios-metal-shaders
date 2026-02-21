//
//  PerspectiveTiltDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.02.2026.
//

import SwiftUI

struct PerspectiveTiltDemoView: View {
    @State private var amount = 0.32

    var body: some View {
        ShaderPreviewCard(
            "Perspective Tilt",
            summary: "Compresses opposite edges to give the image a tilted perspective plane."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.perspectiveTilt(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
            maxSampleOffset: CGSize(width: 120, height: 0)
                    )
                }
        } controls: {
            LabeledContent("Tilt") {
                Slider(value: $amount, in: -0.55...0.55)
            }
        }
    }
}
