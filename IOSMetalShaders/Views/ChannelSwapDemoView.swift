//
//  ChannelSwapDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 12.02.2026.
//

import SwiftUI

struct ChannelSwapDemoView: View {
    @State private var amount = 1.0

    var body: some View {
        ShaderPreviewCard(
            "Channel Swap",
            summary: "Reorders red, green, and blue channels into an electric false-color image."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.channelSwap(
                        .float(Float(amount))
                    )
                )
        } controls: {
            LabeledContent("Swap amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
