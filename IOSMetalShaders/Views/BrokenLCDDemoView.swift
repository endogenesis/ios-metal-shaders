//
//  BrokenLCDDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 08.09.2026.
//

import SwiftUI

struct BrokenLCDDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Broken LCD",
            summary: "Combines frozen columns, dead rows, and fractured LCD color bleed."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.brokenLCD(
                            .float2(proxy.size),
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                            ),
                            maxSampleOffset: CGSize(width: 120, height: 120)
                        )
                    }
            }
        } controls: {
            LabeledContent("Amount") {
                Slider(value: $amount, in: 0...1)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }

}
