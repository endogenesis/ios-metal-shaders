//
//  CRTCurvatureDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 06.09.2026.
//

import SwiftUI

struct CRTCurvatureDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "CRT Curvature",
            summary: "Bows the image toward the curved face of a CRT display."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.crtCurvature(
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
