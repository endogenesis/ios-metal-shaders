//
//  ASCIIArtDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 17.11.2026.
//

import SwiftUI

struct ASCIIArtDemoView: View {
    @State private var cellWidth = 9.0
    @State private var colored = true

    var body: some View {
        ShaderPreviewCard(
            "ASCII Art",
            summary: "Rebuilds the image with ten bitmap characters, from spaces to @."
        ) {
            GeometryReader { geometry in
                ShaderCanvasView(cornerRadius: 0)
                    .layerEffect(
                        ShaderLibrary.asciiArt(
                            .float2(geometry.size),
                            .float(Float(cellWidth)),
                            .float(colored ? 1 : 0)
                        ),
                        maxSampleOffset: CGSize(width: cellWidth, height: cellWidth * 1.5)
                    )
            }
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                LabeledContent("Character size") {
                    Slider(value: $cellWidth, in: 6...18)
                }
                Toggle("Original colors", isOn: $colored)
            }
        }
    }
}

#Preview {
    ASCIIArtDemoView()
        .padding()
}
