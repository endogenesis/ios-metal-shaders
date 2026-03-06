//
//  FilmGrainDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 07.03.2026.
//

import SwiftUI

struct FilmGrainDemoView: View {
    @State private var amount = 0.18

    var body: some View {
        ShaderPreviewCard(
            "Film Grain",
            summary: "Overlays fine animated luminance grain inspired by photographic film."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
                ShaderCanvasView()
                    .colorEffect(
                        ShaderLibrary.filmGrain(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(amount))
                        )
                    )
            }
        } controls: {
            LabeledContent("Grain") {
                Slider(value: $amount, in: 0...0.4)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
