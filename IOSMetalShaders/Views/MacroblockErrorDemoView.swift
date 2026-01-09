//
//  MacroblockErrorDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.01.2026.
//

import SwiftUI

struct MacroblockErrorDemoView: View {
    @State private var displacement = 18.0

    var body: some View {
        ShaderPreviewCard(
            "Macroblock Error",
            summary: "Breaks moving image blocks into displaced, color-split compression errors."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 12)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.macroblockError(
                            .float(shaderTime(for: timeline.date)),
                            .float(24),
                            .float(Float(displacement))
                        ),
                        maxSampleOffset: CGSize(width: displacement, height: 0)
                    )
            }
        } controls: {
            LabeledContent("Displacement") {
                Slider(value: $displacement, in: 0...28)
                    .accessibilityLabel("Macroblock displacement")
                    .accessibilityValue(Text(displacement, format: .number.precision(.fractionLength(0))))
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
