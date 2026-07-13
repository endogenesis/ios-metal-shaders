//
//  HorizontalTearDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.07.2026.
//

import SwiftUI

struct HorizontalTearDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Horizontal Tear",
            summary: "Rips horizontal bands sideways with unstable timing."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.horizontalTear(
                            .float2(proxy.size),
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                            ),
                            maxSampleOffset: CGSize(width: 120, height: 120)
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
