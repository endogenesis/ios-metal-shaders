//
//  VoronoiCellsDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 18.03.2026.
//

import SwiftUI

struct VoronoiCellsDemoView: View {
    @State private var scale = 25.0

    var body: some View {
        ShaderPreviewCard(
            "Voronoi Cells",
            summary: "Facets the image into irregular nearest-point cells with dark boundaries."
        ) {
            ShaderCanvasView()
                .colorEffect(
                    ShaderLibrary.voronoiCells(
                        .float(Float(scale)),
                        .float(0.7)
                    )
                )
        } controls: {
            LabeledContent("Cell size") {
                Slider(value: $scale, in: 10...42)
            }
        }
    }
}
