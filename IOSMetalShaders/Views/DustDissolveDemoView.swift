//
//  DustDissolveDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 23.11.2026.
//

import SwiftUI

struct DustDissolveDemoView: View {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var progress = 0.45
    @State private var shimmer = 0.0
    @State private var grainSize = 1.6
    @State private var direction = 0

    var body: some View {
        let progress = progress
        let shimmer = shimmer
        let grainSize = grainSize
        let direction = direction
        let reduceMotion = reduceMotion

        ShaderPreviewCard(
            "Dust Dissolve",
            summary: "Erodes the image into colored grains with a luminous edge and a sweeping shimmer."
        ) {
            ShaderCanvasView()
                .visualEffect { content, geometry in
                    content.colorEffect(
                        ShaderLibrary.dustDissolve(
                            .float2(geometry.size),
                            .float(Float(progress)),
                            .float(Float(shimmer)),
                            .float(Float(direction)),
                            .float(Float(grainSize))
                        ),
                        isEnabled: !reduceMotion
                    )
                }
                .opacity(reduceMotion ? 1 - progress : 1)
        } controls: {
            VStack {
                LabeledContent("Progress") {
                    Slider(value: $progress, in: 0...1)
                        .accessibilityLabel("Dissolve progress")
                }
                LabeledContent("Grain size") {
                    Slider(value: $grainSize, in: 0.8...4)
                        .accessibilityLabel("Grain size")
                }
                LabeledContent("Shimmer") {
                    Slider(value: $shimmer, in: 0...1)
                        .accessibilityLabel("Shimmer position")
                }
                Picker("Direction", selection: $direction) {
                    Text("Left to right").tag(0)
                    Text("Right to left").tag(1)
                    Text("Top to bottom").tag(2)
                    Text("Bottom to top").tag(3)
                    Text("Center out").tag(4)
                }
                .pickerStyle(.menu)

                HStack {
                    Button("Dissolve", systemImage: "sparkles", action: dissolve)
                    Spacer()
                    Button("Restore", systemImage: "arrow.counterclockwise", action: restore)
                }
                .buttonStyle(.bordered)
            }
        }
    }

    private func dissolve() {
        withAnimation(.linear(duration: reduceMotion ? 0.2 : 2.4)) {
            progress = 1
        }
    }

    private func restore() {
        withAnimation(.linear(duration: reduceMotion ? 0.2 : 1.6)) {
            progress = 0
            shimmer = 0
        }
    }
}

#Preview {
    DustDissolveDemoView()
        .padding()
}
