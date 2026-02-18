//
//  LaplacianEdgesDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.02.2026.
//

import SwiftUI

struct LaplacianEdgesDemoView: View {
    @State private var strength = 1.1

    var body: some View {
        ShaderPreviewCard(
            "Laplacian Edges",
            summary: "Highlights fine contours with a compact Laplacian edge kernel."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.laplacianEdges(
                        .float(Float(strength))
                    ),
                    maxSampleOffset: CGSize(width: 1, height: 1)
                )
        } controls: {
            LabeledContent("Edge strength") {
                Slider(value: $strength, in: 0.3...2.2)
            }
        }
    }
}
