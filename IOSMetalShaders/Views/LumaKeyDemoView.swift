//
//  LumaKeyDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.06.2026.
//

import SwiftUI

struct LumaKeyDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Luma Key",
            summary: "Keys darker tones into transparency using luminance."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.lumaKey(
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
