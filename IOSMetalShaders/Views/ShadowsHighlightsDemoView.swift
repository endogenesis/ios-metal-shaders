//
//  ShadowsHighlightsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 28.03.2026.
//

import SwiftUI

struct ShadowsHighlightsDemoView: View {
    @State private var shadows = 0.35
    @State private var highlights = -0.22

    var body: some View {
        ShaderPreviewCard(
            "Shadows & Highlights",
            summary: "Independently opens dark regions and recovers bright image detail."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.shadowsHighlights(
                        .float(Float(shadows)),
                        .float(Float(highlights))
                    )
                )
        } controls: {
            VStack {
                LabeledContent("Shadows") {
                    Slider(value: $shadows, in: -0.6...0.6)
                }

                LabeledContent("Highlights") {
                    Slider(value: $highlights, in: -0.6...0.6)
                }
            }
        }
    }
}
