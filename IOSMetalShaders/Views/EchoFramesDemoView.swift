//
//  EchoFramesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.03.2026.
//

import SwiftUI

struct EchoFramesDemoView: View {
    @State private var distance = 18.0

    var body: some View {
        ShaderPreviewCard(
            "Echo Frames",
            summary: "Layers offset color echoes that orbit the current image like delayed frames."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.echoFrames(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(distance))
                        ),
                        maxSampleOffset: CGSize(width: distance, height: distance)
                    )
            }
        } controls: {
            LabeledContent("Echo distance") {
                Slider(value: $distance, in: 0...30)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
