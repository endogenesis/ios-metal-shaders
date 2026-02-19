//
//  VHSTrackingDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.02.2026.
//

import SwiftUI

struct VHSTrackingDemoView: View {
    @State private var strength = 15.0

    var body: some View {
        ShaderPreviewCard(
            "VHS Tracking",
            summary: "Adds warped tracking bands, horizontal jitter, and analog color bleed."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.vhsTracking(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength * 1.1, height: 2)
                    )
            }
        } controls: {
            LabeledContent("Tracking error") {
                Slider(value: $strength, in: 0...26)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
