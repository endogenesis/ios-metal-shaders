//
//  BoxBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.02.2026.
//

import SwiftUI

struct BoxBlurDemoView: View {
    @State private var radius = 5.0

    var body: some View {
        ShaderPreviewCard(
            "Box Blur",
            summary: "Averages a square neighborhood into a simple, even blur."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.boxBlur(
                        .float(Float(radius))
                    ),
                    maxSampleOffset: CGSize(width: radius, height: radius)
                )
        } controls: {
            LabeledContent("Radius") {
                Slider(value: $radius, in: 0...12)
            }
        }
    }
}
