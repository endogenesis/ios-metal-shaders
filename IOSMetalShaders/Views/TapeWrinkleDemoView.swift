//
//  TapeWrinkleDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.01.2026.
//

import SwiftUI

struct TapeWrinkleDemoView: View {
    @State private var depth = 12.0

    var body: some View {
        ShaderPreviewCard(
            "Tape Wrinkle",
            summary: "Bends narrow tape bands into shimmering analog creases and color streaks."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.tapeWrinkle(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(depth))
                        ),
                        maxSampleOffset: CGSize(width: depth, height: 0)
                    )
            }
        } controls: {
            LabeledContent("Wrinkle depth") {
                Slider(value: $depth, in: 0...18)
                    .accessibilityLabel("Tape wrinkle depth")
                    .accessibilityValue(Text(depth, format: .number.precision(.fractionLength(0))))
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
