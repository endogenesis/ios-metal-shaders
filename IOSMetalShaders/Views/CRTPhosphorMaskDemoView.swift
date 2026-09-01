//
//  CRTPhosphorMaskDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.09.2026.
//

import SwiftUI

struct CRTPhosphorMaskDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "CRT Phosphor Mask",
            summary: "Applies RGB phosphor stripes and scanline shading."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.crtPhosphorMask(
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
