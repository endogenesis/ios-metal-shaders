//
//  CrosshatchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 27.01.2026.
//

import SwiftUI

struct CrosshatchDemoView: View {
    @State private var strength = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Crosshatch",
            summary: "Layers diagonal ink strokes according to the image luminance."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.crosshatch(
                        .float(9),
                        .float(Float(strength))
                    )
                )
        } controls: {
            LabeledContent("Ink strength") {
                Slider(value: $strength, in: 0...1)
            }
        }
    }
}
