//
//  BorderBeamDemoView.swift
//  IOSMetalShaders
//

import SwiftUI

struct BorderBeamDemoView: View {
    @State private var active = true
    @State private var speed = 1.0
    @State private var intensity = 1.0
    @State private var reversed = false
    @State private var palette = BorderBeamPalettePreset.original

    var body: some View {
        ShaderPreviewCard(
            "Border Beam",
            summary: "A colorful beam follows the border with a soft inner glow."
        ) {
            BorderBeamPreview(
                active: $active,
                direction: reversed ? .rightToLeft : .leftToRight,
                intensity: intensity,
                palette: palette
            )
            .beamSpeed(speed)
        } controls: {
            LabeledContent("Palette") {
                Picker("Palette", selection: $palette) {
                    ForEach(BorderBeamPalettePreset.allCases) { preset in
                        Text(preset.rawValue).tag(preset)
                    }
                }
                .labelsHidden()
            }

            LabeledContent("Speed", value: speed, format: .number.precision(.fractionLength(1)))
            Slider(value: $speed, in: 0...3, step: 0.1) {
                Text("Speed")
            }

            LabeledContent("Intensity", value: intensity, format: .percent.precision(.fractionLength(0)))
            Slider(value: $intensity, in: 0...1) {
                Text("Intensity")
            }

            Toggle("Reverse direction", isOn: $reversed)
            Toggle("Beam active", isOn: $active)
        }
    }
}

#Preview {
    ScrollView {
        BorderBeamDemoView()
            .padding()
    }
}
