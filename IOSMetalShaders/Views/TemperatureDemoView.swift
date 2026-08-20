//
//  TemperatureDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.08.2026.
//

import SwiftUI

struct TemperatureDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Temperature",
            summary: "Shifts the image between cool blue and warm amber light."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.temperature(
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
