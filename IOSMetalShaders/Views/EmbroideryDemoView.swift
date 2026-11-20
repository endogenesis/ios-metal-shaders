//
//  EmbroideryDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.11.2026.
//

import SwiftUI

struct EmbroideryDemoView: View {
    @State private var stitchSize = 10.0
    @State private var relief = 0.8

    var body: some View {
        ShaderPreviewCard(
            "Embroidery",
            summary: "Recreates the image as raised cross-stitches on woven fabric."
        ) {
            GeometryReader { geometry in
                ShaderCanvasView(cornerRadius: 0)
                    .layerEffect(
                        ShaderLibrary.embroidery(
                            .float2(geometry.size),
                            .float(Float(stitchSize)),
                            .float(Float(relief))
                        ),
                        maxSampleOffset: CGSize(width: stitchSize, height: stitchSize)
                    )
            }
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                LabeledContent("Stitch size") {
                    Slider(value: $stitchSize, in: 6...20)
                }
                LabeledContent("Thread relief") {
                    Slider(value: $relief, in: 0...1)
                }
            }
        }
    }
}

#Preview {
    EmbroideryDemoView()
        .padding()
}
