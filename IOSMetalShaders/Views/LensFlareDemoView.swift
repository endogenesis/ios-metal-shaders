//
//  LensFlareDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.03.2026.
//

import SwiftUI

struct LensFlareDemoView: View {
    @State private var intensity = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Lens Flare",
            summary: "Adds a moving optical glow, halo, and small reflections across the lens axis."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            ShaderLibrary.lensFlare(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(intensity))
                            )
                        )
                    }
            }
        } controls: {
            LabeledContent("Intensity") {
                Slider(value: $intensity, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
