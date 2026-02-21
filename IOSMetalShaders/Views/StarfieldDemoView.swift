//
//  StarfieldDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.02.2026.
//

import SwiftUI

struct StarfieldDemoView: View {
    @State private var density = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Starfield",
            summary: "Adds a drifting field of procedural stars with independent twinkles."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            ShaderLibrary.starfield(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(density))
                            )
                        )
                    }
            }
        } controls: {
            LabeledContent("Density") {
                Slider(value: $density, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
