//
//  BlockDisplacementDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.02.2026.
//

import SwiftUI

struct BlockDisplacementDemoView: View {
    @State private var strength = 20.0

    var body: some View {
        ShaderPreviewCard(
            "Block Displacement",
            summary: "Slides rectangular image regions sideways in abrupt digital bursts."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 15)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.blockDisplacement(
                            .float(shaderTime(for: timeline.date)),
                            .float(28),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength, height: 0)
                    )
            }
        } controls: {
            LabeledContent("Strength") {
                Slider(value: $strength, in: 0...36)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
