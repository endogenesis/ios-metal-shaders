//
//  PixelSortingDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.01.2026.
//

import SwiftUI

struct PixelSortingDemoView: View {
    @State private var amount = 1.0
    @State private var thresholdMinimum = 0.18
    @State private var thresholdMaximum = 0.9
    @State private var direction = Direction.horizontal
    @State private var key = SortKey.luminance
    @State private var descending = false

    var body: some View {
        ShaderPreviewCard(
            "Pixel Sorting",
            summary: "Actually reorders thresholded pixel runs with a GPU compute kernel."
        ) {
            ZStack {
                // This also gives the representable a real layout size and acts
                // as a graceful fallback if Metal cannot create a drawable.
                ShaderCanvasView()

                PixelSortingMetalView(
                    amount: Float(amount),
                    thresholdMinimum: Float(min(thresholdMinimum, thresholdMaximum)),
                    thresholdMaximum: Float(max(thresholdMinimum, thresholdMaximum)),
                    direction: direction.rawValue,
                    keyMode: key.rawValue,
                    descending: descending
                ) {
                    ShaderCanvasView()
                }
                .allowsHitTesting(false)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(16 / 10, contentMode: .fit)
            .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
        } controls: {
            VStack {
                Picker("Direction", selection: $direction) {
                    ForEach(Direction.allCases) { direction in
                        Text(direction.title).tag(direction)
                    }
                }
                .pickerStyle(.segmented)

                Picker("Sort key", selection: $key) {
                    ForEach(SortKey.allCases) { key in
                        Text(key.title).tag(key)
                    }
                }
                .pickerStyle(.segmented)

                LabeledContent("Lower threshold") {
                    Slider(value: $thresholdMinimum, in: 0...1)
                }

                LabeledContent("Upper threshold") {
                    Slider(value: $thresholdMaximum, in: 0...1)
                }

                LabeledContent("Sorted amount") {
                    Slider(value: $amount, in: 0...1)
                }

                Toggle("Descending order", isOn: $descending)
            }
        }
    }
}

private extension PixelSortingDemoView {
    enum Direction: UInt32, CaseIterable, Identifiable {
        case horizontal
        case vertical

        var id: Self { self }

        var title: String {
            switch self {
            case .horizontal:
                "Horizontal"
            case .vertical:
                "Vertical"
            }
        }
    }

    enum SortKey: UInt32, CaseIterable, Identifiable {
        case luminance
        case hue
        case saturation

        var id: Self { self }

        var title: String {
            switch self {
            case .luminance:
                "Luma"
            case .hue:
                "Hue"
            case .saturation:
                "Chroma"
            }
        }
    }
}
