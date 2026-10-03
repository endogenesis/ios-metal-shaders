//
//  OutlineDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.08.2026.
//

import SwiftUI

struct OutlineDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Outline",
            summary: "Adds a clean dark outline along image contours."
        ) {
            ShaderCanvasView(cornerRadius: 0)
                .visualEffect { [amount] content, proxy in
                    content.layerEffect(
                        ShaderLibrary.outline(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 5, height: 5)
                    )
                }
                .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            LabeledContent("Outline strength") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
