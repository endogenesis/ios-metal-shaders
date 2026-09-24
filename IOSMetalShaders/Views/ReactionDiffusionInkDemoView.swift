//
//  ReactionDiffusionInkDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 24.09.2026.
//

import SwiftUI

struct ReactionDiffusionInkDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false
    @State private var mode = 0
    @State private var touch = SIMD2<Float>(0.5, 0.5)
    @State private var isTouching = false
    @State private var resetToken = 0

    var body: some View {
        ShaderPreviewCard(
            "Reaction-Diffusion Ink",
            summary: "Grows touchable Gray-Scott patterns over the scene."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion || !isVisible)) { _ in
                GeometryReader { geometry in
                    ZStack {
                        ShaderCanvasView()
                        MetalEffectView(
                            parameters: MetalEffectParameters(
                                kind: .reactionDiffusion,
                                mode: UInt32(mode),
                                center: touch,
                                touching: isTouching,
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
                                touch = SIMD2<Float>(
                                    Float(min(max(value.location.x / max(geometry.size.width, 1), 0), 1)),
                                    Float(min(max(value.location.y / max(geometry.size.height, 1), 0), 1))
                                )
                                isTouching = true
                            }
                            .onEnded { _ in isTouching = false }
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
                Picker("Pattern", selection: $mode) {
                    Text("Coral").tag(0)
                    Text("Mitosis").tag(1)
                    Text("Worms").tag(2)
                }
                .pickerStyle(.segmented)
                Button("Reset ink") { resetToken += 1 }
            }
        }
    }
}
