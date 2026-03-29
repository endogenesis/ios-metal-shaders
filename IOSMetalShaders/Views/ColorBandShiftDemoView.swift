//
//  ColorBandShiftDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.03.2026.
//

import SwiftUI

struct ColorBandShiftDemoView: View {
    @State private var strength = 16.0

    var body: some View {
        ShaderPreviewCard(
            "Color Band Shift",
            summary: "Offsets color channels independently inside animated horizontal bands."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.colorBandShift(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength, height: 0)
                    )
            }
        } controls: {
            LabeledContent("Shift") {
                Slider(value: $strength, in: 0...28)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
