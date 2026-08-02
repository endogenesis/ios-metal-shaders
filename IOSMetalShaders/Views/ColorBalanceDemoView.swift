//
//  ColorBalanceDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 02.08.2026.
//

import SwiftUI

struct ColorBalanceDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Color Balance",
            summary: "Balances cool shadows against warm highlights."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.colorBalance(
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
