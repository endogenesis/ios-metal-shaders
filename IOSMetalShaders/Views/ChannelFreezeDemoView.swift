//
//  ChannelFreezeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.01.2026.
//

import SwiftUI

struct ChannelFreezeDemoView: View {
    @State private var amount = 0.72

    var body: some View {
        ShaderPreviewCard(
            "Channel Freeze",
            summary: "Locks individual color channels into neighboring signal bands."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 15)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.channelFreeze(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 0, height: 18)
                    )
            }
        } controls: {
            LabeledContent("Freeze amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
