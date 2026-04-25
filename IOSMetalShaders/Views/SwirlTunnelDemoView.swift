//
//  SwirlTunnelDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 25.04.2026.
//

import SwiftUI

struct SwirlTunnelDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Swirl Tunnel",
            summary: "Pulls the image through a rotating tunnel."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .visualEffect { content, proxy in
                        content.distortionEffect(
                            ShaderLibrary.swirlTunnel(
                            .float2(proxy.size),
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                            ),
                            maxSampleOffset: CGSize(width: 120, height: 90)
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
