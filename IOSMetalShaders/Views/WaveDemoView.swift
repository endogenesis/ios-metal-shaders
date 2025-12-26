//
//  WaveDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct WaveDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var amplitude = 10.0

    var body: some View {
        ShaderPreviewCard(
            "Wave",
            summary: "Offsets each sampled pixel with a moving sine wave."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion)) { timeline in
                ShaderCanvasView()
                    .distortionEffect(
                        ShaderLibrary.wave(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amplitude)),
                            .float(32)
                        ),
                        maxSampleOffset: CGSize(width: 0, height: amplitude)
                    )
            }
        } controls: {
            LabeledContent("Amplitude") {
                Slider(value: $amplitude, in: 0...20)
                    .accessibilityLabel("Wave amplitude")
                    .accessibilityValue(
                        Text(amplitude, format: .number.precision(.fractionLength(0)))
                    )
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        guard !reduceMotion else { return 0 }
        return Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
