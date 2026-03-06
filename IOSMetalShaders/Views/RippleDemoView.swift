//
//  RippleDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 06.03.2026.
//

import SwiftUI

struct RippleDemoView: View {
    @State private var amplitude = 9.0

    var body: some View {
        ShaderPreviewCard(
            "Ripple",
            summary: "Sends animated circular waves outward from the image center."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.distortionEffect(
                            ShaderLibrary.ripple(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(amplitude)),
                                .float(15)
                            ),
                            maxSampleOffset: CGSize(width: amplitude, height: amplitude)
                        )
                    }
            }
        } controls: {
            LabeledContent("Amplitude") {
                Slider(value: $amplitude, in: 0...16)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
