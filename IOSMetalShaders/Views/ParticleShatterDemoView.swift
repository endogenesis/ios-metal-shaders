//
//  ParticleShatterDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.09.2026.
//

import SwiftUI

struct ParticleShatterDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress = 0.45
    @State private var intensity = 0.85

    var body: some View {
        ShaderPreviewCard(
            "Particle Shatter / Reassemble",
            summary: "Breaks a scene into thousands of independently moving textured tiles."
        ) {
            ZStack {
                Color.black
                if reduceMotion {
                    ShaderCanvasView()
                        .opacity(1 - progress)
                        .scaleEffect(1 - progress * 0.08)
                } else {
                    MetalEffectView(
                        parameters: MetalEffectParameters(
                            kind: .particles,
                            progress: Float(progress),
                            intensity: Float(intensity)
                        )
                    ) {
                        ShaderCanvasView()
                    }
                    .allowsHitTesting(false)
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                LabeledContent("Shatter / reassemble") {
                    Slider(value: $progress, in: 0...1)
                }
                LabeledContent("Spread") {
                    Slider(value: $intensity, in: 0.2...1)
                }
            }
        }
    }
}
