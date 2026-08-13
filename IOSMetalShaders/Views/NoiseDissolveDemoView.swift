//
//  NoiseDissolveDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.08.2026.
//

import SwiftUI

struct NoiseDissolveDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Noise Dissolve",
            summary: "Dissolves the image through a restless granular mask."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.noiseDissolve(
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
