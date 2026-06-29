//
//  SignalNoiseDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.06.2026.
//

import SwiftUI

struct SignalNoiseDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Signal Noise",
            summary: "Mixes chroma noise into an unstable broadcast signal."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.signalNoise(
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
