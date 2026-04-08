//
//  DisplacementNoiseDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.04.2026.
//

import SwiftUI

struct DisplacementNoiseDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Displacement Noise",
            summary: "Warps the image with blocky animated noise."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.displacementNoise(
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
