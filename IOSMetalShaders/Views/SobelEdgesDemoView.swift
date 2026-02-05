//
//  SobelEdgesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.02.2026.
//

import SwiftUI

struct SobelEdgesDemoView: View {
    @State private var strength = 1.25

    var body: some View {
        ShaderPreviewCard(
            "Sobel Edges",
            summary: "Extracts image contours with horizontal and vertical Sobel kernels."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.sobelEdges(
                        .float(Float(strength))
                    ),
                    maxSampleOffset: CGSize(width: 1, height: 1)
                )
        } controls: {
            LabeledContent("Edge strength") {
                Slider(value: $strength, in: 0.4...2.5)
            }
        }
    }
}
