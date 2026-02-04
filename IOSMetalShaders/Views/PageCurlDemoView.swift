//
//  PageCurlDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 04.02.2026.
//

import SwiftUI

struct PageCurlDemoView: View {
    @State private var progress = 0.55

    var body: some View {
        ShaderPreviewCard(
            "Page Curl",
            summary: "Folds the image edge into a curved page-like transition."
        ) {
            ShaderCanvasView()
                .visualEffect { content, proxy in
                    content.distortionEffect(
                        ShaderLibrary.pageCurl(
                            .float2(proxy.size),
                            .float(Float(progress)),
                            .float(28)
                        ),
                        maxSampleOffset: CGSize(width: 28, height: 18)
                    )
                }
        } controls: {
            LabeledContent("Curl progress") {
                Slider(value: $progress, in: 0...1)
            }
        }
    }
}
