//
//  FireDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 10.02.2026.
//

import SwiftUI

struct FireDemoView: View {
    @State private var intensity = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Fire",
            summary: "Builds rising procedural flames from layered animated noise."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            ShaderLibrary.fire(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(intensity))
                            )
                        )
                    }
            }
        } controls: {
            LabeledContent("Flame intensity") {
                Slider(value: $intensity, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
