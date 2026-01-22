//
//  BarcodeGlitchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 22.01.2026.
//

import SwiftUI

struct BarcodeGlitchDemoView: View {
    @State private var strength = 16.0

    var body: some View {
        ShaderPreviewCard(
            "Barcode Glitch",
            summary: "Slices the signal into flickering vertical bars with uneven channel offsets."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.barcodeGlitch(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength, height: 0)
                    )
            }
        } controls: {
            LabeledContent("Bar displacement") {
                Slider(value: $strength, in: 0...28)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
