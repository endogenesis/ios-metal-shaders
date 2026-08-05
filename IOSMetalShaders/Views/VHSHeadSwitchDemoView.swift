//
//  VHSHeadSwitchDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 05.08.2026.
//

import SwiftUI

struct VHSHeadSwitchDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "VHS Head Switch",
            summary: "Rolls and bends the lower frame like a misaligned VHS head."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.layerEffect(
                            ShaderLibrary.vhsHeadSwitch(
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
