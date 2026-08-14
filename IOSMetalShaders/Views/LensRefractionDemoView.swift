//
//  LensRefractionDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.08.2026.
//

import SwiftUI

struct LensRefractionDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Lens Refraction",
            summary: "Refracts the image through a rounded optical lens."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.lensRefraction(
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
