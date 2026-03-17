//
//  BarrelDistortionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.03.2026.
//

import SwiftUI

struct BarrelDistortionDemoView: View {
    @State private var strength = 0.18

    var body: some View {
        ShaderPreviewCard(
            "Barrel Distortion",
            summary: "Bows straight lines outward with a classic wide-angle barrel curve."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.barrelDistortion(
                            .float2(proxy.size),
                            .float(Float(strength))
                        ),
            maxSampleOffset: CGSize(width: 140, height: 90)
                    )
                }
        } controls: {
            LabeledContent("Curvature") {
                Slider(value: $strength, in: 0...0.3)
            }
        }
    }
}
