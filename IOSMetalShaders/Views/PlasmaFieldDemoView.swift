//
//  PlasmaFieldDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 14.04.2026.
//

import SwiftUI

struct PlasmaFieldDemoView: View {
    @State private var amount = 0.65

    var body: some View {
        ShaderPreviewCard(
            "Plasma Field",
            summary: "Flows through layered waves of electric plasma color."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.plasmaField(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                        )
                    )
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
