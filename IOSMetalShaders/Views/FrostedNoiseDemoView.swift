//
//  FrostedNoiseDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.01.2026.
//

import SwiftUI

struct FrostedNoiseDemoView: View {
    @State private var radius = 6.0

    var body: some View {
        ShaderPreviewCard(
            "Frosted Noise",
            summary: "Scatters nearby pixels into a softly animated frosted-glass texture."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.frostedNoise(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(radius)),
                            .float(0.72)
                        ),
                        maxSampleOffset: CGSize(width: radius, height: radius)
                    )
            }
        } controls: {
            LabeledContent("Scatter radius") {
                Slider(value: $radius, in: 0...12)
                    .accessibilityLabel("Frosted noise scatter radius")
                    .accessibilityValue(Text(radius, format: .number.precision(.fractionLength(0))))
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
