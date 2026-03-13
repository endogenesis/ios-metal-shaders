//
//  MagnifyingGlassDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 13.03.2026.
//

import SwiftUI

struct MagnifyingGlassDemoView: View {
    @State private var zoom = 2.2

    var body: some View {
        ShaderPreviewCard(
            "Magnifying Glass",
            summary: "Magnifies a circular region and draws a subtle glass rim around it."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.layerEffect(
                        ShaderLibrary.magnifyingGlass(
                            .float2(proxy.size),
                            .float(Float(zoom)),
                            .float(68)
                        ),
                        maxSampleOffset: CGSize(width: 50, height: 50)
                    )
                }
        } controls: {
            LabeledContent("Magnification") {
                Slider(value: $zoom, in: 1...3.5)
            }
        }
    }
}
