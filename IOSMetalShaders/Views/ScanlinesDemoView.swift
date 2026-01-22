//
//  ScanlinesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct ScanlinesDemoView: View {
    @State private var intensity = 0.45

    var body: some View {
        ShaderPreviewCard(
            "Scanlines",
            summary: "Darkens horizontal bands and moves them over time."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.scanlines(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(intensity))
                        )
                    )
            }
        } controls: {
            LabeledContent("Intensity") {
                Slider(value: $intensity, in: 0...0.8)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        return Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
