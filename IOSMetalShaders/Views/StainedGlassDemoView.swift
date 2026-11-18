//
//  StainedGlassDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.11.2026.
//

import SwiftUI

struct StainedGlassDemoView: View {
    @State private var cellSize = 28.0
    @State private var seamWidth = 1.5

    var body: some View {
        ShaderPreviewCard(
            "Stained Glass",
            summary: "Turns the image into colored glass pieces with raised lead seams."
        ) {
            GeometryReader { geometry in
                ShaderCanvasView(cornerRadius: 0)
                    .layerEffect(
                        ShaderLibrary.stainedGlass(
                            .float2(geometry.size),
                            .float(Float(cellSize)),
                            .float(Float(seamWidth))
                        ),
                        maxSampleOffset: CGSize(width: cellSize * 2, height: cellSize * 2)
                    )
            }
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                LabeledContent("Glass size") {
                    Slider(value: $cellSize, in: 14...54)
                }
                LabeledContent("Lead width") {
                    Slider(value: $seamWidth, in: 0.6...3)
                }
            }
        }
    }
}

#Preview {
    StainedGlassDemoView()
        .padding()
}
