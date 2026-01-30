//
//  DuotoneDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 30.01.2026.
//

import SwiftUI

struct DuotoneDemoView: View {
    @State private var amount = 1.0

    var body: some View {
        ShaderPreviewCard(
            "Duotone",
            summary: "Maps luminance between deep indigo shadows and warm amber highlights."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.duotone(
                        .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
