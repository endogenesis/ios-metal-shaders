//
//  ThresholdDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.08.2026.
//

import SwiftUI

struct ThresholdDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Threshold",
            summary: "Converts luminance into a stark adjustable two-tone mask."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.threshold(
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
