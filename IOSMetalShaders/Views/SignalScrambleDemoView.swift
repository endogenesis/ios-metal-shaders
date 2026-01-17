//
//  SignalScrambleDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.01.2026.
//

import SwiftUI

struct SignalScrambleDemoView: View {
    @State private var strength = 22.0

    var body: some View {
        ShaderPreviewCard(
            "Signal Scramble",
            summary: "Scrambles fast horizontal signal slices with noisy color interference."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.signalScramble(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength * 1.2, height: 6)
                    )
            }
        } controls: {
            LabeledContent("Scramble strength") {
                Slider(value: $strength, in: 0...32)
                    .accessibilityLabel("Signal scramble strength")
                    .accessibilityValue(Text(strength, format: .number.precision(.fractionLength(0))))
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
