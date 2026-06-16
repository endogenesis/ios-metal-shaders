//
//  PolarWarpDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.06.2026.
//

import SwiftUI

struct PolarWarpDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Polar Warp",
            summary: "Wraps Cartesian space into a polar spiral."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.polarWarp(
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
