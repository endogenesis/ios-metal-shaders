//
//  StippleDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.03.2026.
//

import SwiftUI

struct StippleDemoView: View {
    @State private var scale = 8.0

    var body: some View {
        ShaderPreviewCard(
            "Stipple",
            summary: "Translates luminance into scattered ink dots with hand-made spacing."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.stipple(
                        .float(Float(scale)),
                        .float(0.92)
                    )
                )
        } controls: {
            LabeledContent("Dot spacing") {
                Slider(value: $scale, in: 4...14)
            }
        }
    }
}
