//
//  FisheyeDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.07.2026.
//

import SwiftUI

struct FisheyeDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Fisheye",
            summary: "Curves the image through an ultra-wide fisheye lens."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.fisheye(
                            .float2(proxy.size),
                            .float(Float(amount))
                        ),
                        maxSampleOffset: CGSize(width: 120, height: 90)
                    )
                }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }
}
