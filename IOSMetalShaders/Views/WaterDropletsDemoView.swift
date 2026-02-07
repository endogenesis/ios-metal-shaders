//
//  WaterDropletsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.02.2026.
//

import SwiftUI

struct WaterDropletsDemoView: View {
    @State private var strength = 8.0

    var body: some View {
        ShaderPreviewCard(
            "Water Droplets",
            summary: "Ripples the image through a field of animated glass droplets."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.distortionEffect(
                            ShaderLibrary.waterDroplets(
                                .float2(proxy.size),
                                .float(shaderTime(for: timeline.date)),
                                .float(Float(strength))
                            ),
                            maxSampleOffset: CGSize(width: strength, height: strength)
                        )
                    }
            }
        } controls: {
            LabeledContent("Refraction") {
                Slider(value: $strength, in: 0...14)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
