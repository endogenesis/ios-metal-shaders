//
//  MotionBlurDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 20.03.2026.
//

import SwiftUI

struct MotionBlurDemoView: View {
    @State private var distance = 14.0

    var body: some View {
        ShaderPreviewCard(
            "Motion Blur",
            summary: "Trails samples behind a fixed movement direction to imply speed."
        ) {
            ShaderCanvasView()
                .layerEffect(
                    ShaderLibrary.motionBlur(
                        .float(Float(distance)),
                        .float(0.3)
                    ),
                    maxSampleOffset: CGSize(width: distance, height: distance)
                )
        } controls: {
            LabeledContent("Distance") {
                Slider(value: $distance, in: 0...28)
            }
        }
    }
}
