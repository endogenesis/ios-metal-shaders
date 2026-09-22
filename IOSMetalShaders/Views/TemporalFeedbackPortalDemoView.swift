//
//  TemporalFeedbackPortalDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.09.2026.
//

import SwiftUI

struct TemporalFeedbackPortalDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false
    @State private var intensity = 0.65
    @State private var center = SIMD2<Float>(0.5, 0.5)
    @State private var resetToken = 0

    var body: some View {
        ShaderPreviewCard(
            "Temporal Feedback Portal",
            summary: "Feeds past frames back through a rotating tunnel."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion || !isVisible)) { _ in
                GeometryReader { geometry in
                    ZStack {
                        ShaderCanvasView()
                        MetalEffectView(
                            parameters: MetalEffectParameters(
                                kind: .feedback,
                                intensity: Float(intensity),
                                center: center,
                                resetToken: resetToken
                            )
                        ) {
                            ShaderCanvasView()
                        }
                        .allowsHitTesting(false)
                    }
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                center = SIMD2<Float>(
                                    Float(min(max(value.location.x / max(geometry.size.width, 1), 0), 1)),
                                    Float(min(max(value.location.y / max(geometry.size.height, 1), 0), 1))
                                )
                            }
                    )
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(16 / 10, contentMode: .fit)
                .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
            }
            .onAppear { isVisible = true }
            .onDisappear { isVisible = false }
        } controls: {
            VStack {
                LabeledContent("Tunnel strength") {
                    Slider(value: $intensity, in: 0...1)
                }
                Button("Reset trail") { resetToken += 1 }
            }
        }
    }
}
