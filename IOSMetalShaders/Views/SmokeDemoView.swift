//
//  SmokeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.03.2026.
//

import SwiftUI

struct SmokeDemoView: View {
    @State private var amount = 0.68

    var body: some View {
        ShaderPreviewCard(
            "Smoke",
            summary: "Drifts layered procedural wisps upward over the source image."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.colorEffect(
                            ShaderLibrary.smoke(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(amount))
                            )
                        )
                    }
            }
        } controls: {
            LabeledContent("Density") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
