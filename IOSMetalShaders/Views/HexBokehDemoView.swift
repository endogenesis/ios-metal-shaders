//
//  HexBokehDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.01.2026.
//

import SwiftUI

struct HexBokehDemoView: View {
    @State private var radius = 7.0

    var body: some View {
        ShaderPreviewCard(
            "Hex Bokeh",
            summary: "Blends six neighboring highlights into a soft hexagonal lens pattern."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.hexBokeh(
                        .float(Float(radius)),
                        .float(0.82)
                    ),
                    maxSampleOffset: CGSize(width: radius, height: radius)
                )
        } controls: {
            LabeledContent("Radius") {
                Slider(value: $radius, in: 0...14)
            }
        }
    }
}
