//
//  GammaDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.03.2026.
//

import SwiftUI

struct GammaDemoView: View {
    @State private var gamma = 1.35

    var body: some View {
        ShaderPreviewCard(
            "Gamma",
            summary: "Remaps midtones with a configurable gamma response curve."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.gamma(
                        .float(Float(gamma))
                    )
                )
        } controls: {
            LabeledContent("Gamma") {
                Slider(value: $gamma, in: 0.4...2.5)
            }
        }
    }
}
