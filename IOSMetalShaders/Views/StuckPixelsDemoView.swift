//
//  StuckPixelsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.06.2026.
//

import SwiftUI

struct StuckPixelsDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Stuck Pixels",
            summary: "Scatters frozen bright pixels across the display."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.stuckPixels(
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
