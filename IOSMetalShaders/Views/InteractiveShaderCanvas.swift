//
//  InteractiveShaderCanvas.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.11.2026.
//

import SwiftUI

/// Supplies local time and a normalized drag position to animated layer shaders.
struct InteractiveShaderCanvas: View {
    var maxSampleOffset: CGSize = .zero
    let shader: (CGSize, Float, CGPoint) -> Shader

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var isVisible = false
    @State private var startDate = Date()
    @State private var pointer = CGPoint(x: 0.5, y: 0.5)

    var body: some View {
        GeometryReader { geometry in
            TimelineView(.animation(minimumInterval: 1 / 30, paused: reduceMotion || !isVisible)) { timeline in
                let time = reduceMotion ? 0 : Float(timeline.date.timeIntervalSince(startDate))

                ShaderCanvasView(cornerRadius: 0)
                    .layerEffect(
                        shader(geometry.size, time, pointer),
                        maxSampleOffset: maxSampleOffset
                    )
            }
            .contentShape(.rect)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        pointer = CGPoint(
                            x: min(max(value.location.x / max(geometry.size.width, 1), 0), 1),
                            y: min(max(value.location.y / max(geometry.size.height, 1), 0), 1)
                        )
                    }
            )
        }
        .aspectRatio(16 / 10, contentMode: .fit)
        .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        .onAppear { isVisible = true }
        .onDisappear { isVisible = false }
    }
}
