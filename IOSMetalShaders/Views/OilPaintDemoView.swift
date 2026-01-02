//
//  OilPaintDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.01.2026.
//

import SwiftUI

struct OilPaintDemoView: View {
    @State private var radius = 3.0

    var body: some View {
        ShaderPreviewCard(
            "Oil Paint",
            summary: "Chooses the smoothest neighboring color region for a painted look."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.oilPaint(
                        .float(Float(radius))
                    ),
                    maxSampleOffset: CGSize(width: radius, height: radius)
                )
        } controls: {
            LabeledContent("Brush size") {
                Slider(value: $radius, in: 1...6, step: 1)
                    .accessibilityLabel("Oil paint brush size")
                    .accessibilityValue(Text(radius, format: .number))
            }
        }
    }
}
