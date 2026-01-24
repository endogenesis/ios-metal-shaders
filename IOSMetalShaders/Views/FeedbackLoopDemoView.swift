//
//  FeedbackLoopDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.01.2026.
//

import SwiftUI

struct FeedbackLoopDemoView: View {
    @State private var amount = 16.0

    var body: some View {
        ShaderPreviewCard(
            "Feedback Loop",
            summary: "Repeats shrinking, rotating samples to mimic a recursive video feed."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.feedbackLoop(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(amount))
                            ),
                            maxSampleOffset: CGSize(width: amount * 1.3, height: amount * 1.3)
                        )
                    }
            }
        } controls: {
            LabeledContent("Feedback") {
                Slider(value: $amount, in: 0...28)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
