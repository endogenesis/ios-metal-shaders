//
//  CRTSyncLossDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 09.02.2026.
//

import SwiftUI

struct CRTSyncLossDemoView: View {
    @State private var strength = 18.0

    var body: some View {
        ShaderPreviewCard(
            "CRT Sync Loss",
            summary: "Knocks horizontal CRT bands out of sync with unstable channel alignment."
        ) {
            TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
                ShaderCanvasView()
                    .layerEffect(
                        ShaderLibrary.crtSyncLoss(
                            .float(shaderTime(for: timeline.date)),
                            .float(Float(strength))
                        ),
                        maxSampleOffset: CGSize(width: strength, height: 4)
                    )
            }
        } controls: {
            LabeledContent("Sync loss") {
                Slider(value: $strength, in: 0...30)
            }
        }
    }

    private func shaderTime(for date: Date) -> Float {
        Float(date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 60))
    }
}
