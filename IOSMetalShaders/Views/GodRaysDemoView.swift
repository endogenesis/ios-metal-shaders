//
//  GodRaysDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.06.2026.
//

import SwiftUI

struct GodRaysDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "God Rays",
            summary: "Draws luminous rays from a moving light source."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.godRays(
                            .float2(proxy.size),
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                            ),
                            maxSampleOffset: CGSize(width: 96, height: 96)
                        )
                    }
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
