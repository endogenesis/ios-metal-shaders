// Prompt, ring and search examples adapted from ismnoiet/border-beam-ios (MIT).
// Copyright (c) 2026 ismnoiet. See ThirdPartyNotices/BorderBeam-LICENSE.txt.

import SwiftUI

struct BorderBeamPreview: View {
    @Binding var active: Bool
    let direction: BeamDirection
    let intensity: Double
    let palette: BorderBeamPalettePreset

    @State private var prompt = ""
    @State private var query = ""
    @State private var mode = "Agent"
    @State private var model = "Auto"

    var body: some View {
        VStack(spacing: 16) {
            Text("Large")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))

            BorderBeam(
                shape: .rounded(26),
                direction: direction,
                active: active,
                colors: palette.colors,
                intensity: intensity
            ) {
                VStack(alignment: .leading, spacing: 16) {
                    Image(systemName: "at")
                        .font(.subheadline.weight(.medium))
                        .foregroundStyle(.white.opacity(0.6))
                        .frame(width: 26, height: 26)
                        .background(.white.opacity(0.06), in: .circle)
                        .accessibilityHidden(true)

                    TextField("Build anything...", text: $prompt)
                        .textFieldStyle(.plain)
                        .font(.subheadline)

                    HStack(spacing: 8) {
                        BorderBeamMenu(title: "Mode", selection: $mode, options: ["Agent", "Ask", "Plan"])
                        BorderBeamMenu(title: "Model", selection: $model, options: ["Auto", "Fast", "Pro"])

                        Spacer(minLength: 0)

                        Button("Toggle beam", systemImage: "arrow.up", action: toggleBeam)
                            .labelStyle(.iconOnly)
                            .font(.caption.weight(.medium))
                            .frame(width: 44, height: 44)
                            .background {
                                Circle()
                                    .fill(.white.opacity(0.08))
                                    .frame(width: 30, height: 30)
                            }
                            .accessibilityValue(active ? "Active" : "Inactive")
                    }
                    .pickerStyle(.menu)
                    .tint(.white.opacity(0.75))
                    .font(.caption)
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            Text("Small")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))

            BorderBeam(
                .small,
                shape: .circle,
                direction: direction,
                active: active,
                colors: palette.controlColors,
                intensity: intensity
            ) {
                Button(active ? "Stop beam" : "Start beam", systemImage: active ? "stop.fill" : "play.fill", action: toggleBeam)
                    .labelStyle(.iconOnly)
                    .font(.caption2)
                    .foregroundStyle(.white.opacity(0.75))
                    .frame(width: 44, height: 44)
            }

            Text("Line")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.4))

            BorderBeam(
                .line,
                shape: .capsule,
                active: active,
                colors: palette.controlColors,
                intensity: intensity
            ) {
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .accessibilityHidden(true)
                    TextField("Search", text: $query)
                        .textFieldStyle(.plain)
                }
                .font(.subheadline)
                .foregroundStyle(.white.opacity(0.5))
                .padding(.horizontal, 14)
                .frame(height: 44)
            }
        }
        .buttonStyle(.plain)
        .foregroundStyle(.white)
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(Color(white: 0.09), in: .rect(cornerRadius: AppTheme.previewCornerRadius))
        .environment(\.colorScheme, .dark)
    }

    private func toggleBeam() {
        active.toggle()
    }
}
