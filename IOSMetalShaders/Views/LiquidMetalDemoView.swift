//
//  LiquidMetalDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 16.11.2026.
//

import SwiftUI

struct LiquidMetalDemoView: View {
    @State private var amount = 0.9
    @State private var speed = 0.7

    var body: some View {
        ShaderPreviewCard(
            "Liquid Metal",
            summary: "Flowing chrome with image relief. Drag to move a liquid dent."
        ) {
            InteractiveShaderCanvas(maxSampleOffset: CGSize(width: 2, height: 2)) { size, time, pointer in
                ShaderLibrary.liquidMetal(
                    .float2(size),
                    .float(time * Float(speed)),
                    .float2(Float(pointer.x), Float(pointer.y)),
                    .float(Float(amount))
                )
            }
        } controls: {
            VStack {
                LabeledContent("Chrome amount") {
                    Slider(value: $amount, in: 0...1)
                }
                LabeledContent("Flow speed") {
                    Slider(value: $speed, in: 0...2)
                }
            }
        }
    }
}

#Preview {
    LiquidMetalDemoView()
        .padding()
}
