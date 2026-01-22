//
//  HueRotationDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 03.01.2026.
//

import SwiftUI

struct HueRotationDemoView: View {
    @State private var angle = 120.0

    var body: some View {
        ShaderPreviewCard(
            "Hue Rotation",
            summary: "Rotates every color around the hue wheel while preserving its luminance."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.hueRotation(
                        .float(Float(angle * .pi / 180))
                    )
                )
        } controls: {
            LabeledContent("Angle") {
                Slider(value: $angle, in: 0...360)
            }
        }
    }
}
