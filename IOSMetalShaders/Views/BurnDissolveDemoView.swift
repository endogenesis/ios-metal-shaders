//
//  BurnDissolveDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.01.2026.
//

import SwiftUI

struct BurnDissolveDemoView: View {
    @State private var progress = 0.38

    var body: some View {
        ShaderPreviewCard(
            "Burn Dissolve",
            summary: "Dissolves the image through an irregular mask edged with glowing embers."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.burnDissolve(
                        .float(Float(progress)),
                        .float(18)
                    )
                )
        } controls: {
            LabeledContent("Progress") {
                Slider(value: $progress, in: 0...1)
            }
        }
    }
}
