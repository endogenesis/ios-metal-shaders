//
//  CheckerPatternDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 11.05.2026.
//

import SwiftUI

struct CheckerPatternDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Checker Pattern",
            summary: "Overlays a graphic checkerboard on the image."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.checkerPattern(
                            .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
