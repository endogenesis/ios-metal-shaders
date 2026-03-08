//
//  BrightnessDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.03.2026.
//

import SwiftUI

struct BrightnessDemoView: View {
    @State private var brightness = 0.18

    var body: some View {
        ShaderPreviewCard(
            "Brightness",
            summary: "Raises or lowers every color channel by a uniform exposure offset."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.brightness(
                        .float(Float(brightness))
                    )
                )
        } controls: {
            LabeledContent("Brightness") {
                Slider(value: $brightness, in: -0.5...0.5)
            }
        }
    }
}
