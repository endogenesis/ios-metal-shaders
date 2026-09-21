//
//  DualTextureMorphDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 21.09.2026.
//

import SwiftUI

struct DualTextureMorphDemoView: View {
    @State private var progress = 0.48
    @State private var mode = 0

    var body: some View {
        ShaderPreviewCard(
            "Dual-Texture Morph",
            summary: "Moves two SwiftUI scenes through a matched displacement field."
        ) {
            ZStack {
                ShaderCanvasView()
                MetalEffectView(
                    parameters: MetalEffectParameters(
                        kind: .morph,
                        progress: Float(progress),
                        intensity: 0.9,
                        mode: UInt32(mode)
                    )
                ) {
                    ShaderCanvasView()
                } target: {
                    ZStack {
                        LinearGradient(
                            colors: [.purple, .blue, .black],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        Image(systemName: "moon.stars.fill")
                            .font(.system(size: 84))
                            .foregroundStyle(.yellow)
                        VStack {
                            Spacer()
                            Text("NIGHT")
                                .font(.title2.bold())
                                .foregroundStyle(.white)
                                .padding(.bottom)
                        }
                    }
                }
                .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                Picker("Morph style", selection: $mode) {
                    Text("Melt").tag(0)
                    Text("Shards").tag(1)
                    Text("Smoke").tag(2)
                }
                .pickerStyle(.segmented)
                LabeledContent("Progress") {
                    Slider(value: $progress, in: 0...1)
                }
            }
        }
    }
}
