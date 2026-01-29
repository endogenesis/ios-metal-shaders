//
//  RollingScanlinesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 29.01.2026.
//

import SwiftUI

struct RollingScanlinesDemoView: View {
    @State private var intensity = 0.48

    var body: some View {
        ShaderPreviewCard(
            "Rolling Scanlines",
            summary: "Moves dense scanlines and a bright synchronization band down the image."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.rollingScanlines(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(intensity))
                        )
                    )
            }
        } controls: {
            LabeledContent("Intensity") {
                Slider(value: $intensity, in: 0...0.85)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
