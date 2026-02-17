//
//  WatercolorDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.02.2026.
//

import SwiftUI

struct WatercolorDemoView: View {
    @State private var radius = 5.0

    var body: some View {
        ShaderPreviewCard(
            "Watercolor",
            summary: "Softens pigment regions and adds subtle paper-like color variation."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.watercolor(
                        .float(Float(radius)),
                        .float(0.78)
                    ),
                    maxSampleOffset: CGSize(width: radius, height: radius)
                )
        } controls: {
            LabeledContent("Wash radius") {
                Slider(value: $radius, in: 1...10)
            }
        }
    }
}
