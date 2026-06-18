//
//  ColorQuantizationGlitchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.06.2026.
//

import SwiftUI

struct ColorQuantizationGlitchDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Color Quantization Glitch",
            summary: "Snaps colors into unstable, shifting digital bands."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.colorQuantizationGlitch(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                        )
                    )
            }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }

}
