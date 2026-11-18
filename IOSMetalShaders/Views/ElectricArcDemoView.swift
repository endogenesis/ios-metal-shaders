//
//  ElectricArcDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 19.11.2026.
//

import SwiftUI

struct ElectricArcDemoView: View {
    @State private var energy = 0.7
    @State private var palette = 0

    var body: some View {
        ShaderPreviewCard(
            "Electric Arc",
            summary: "Drag the endpoint of branching lightning with a white-hot core."
        ) {
            InteractiveShaderCanvas { size, time, pointer in
                ShaderLibrary.electricArc(
                    .float2(size),
                    .float(time),
                    .float2(Float(pointer.x), Float(pointer.y)),
                    .float(Float(energy)),
                    .float(Float(palette))
                )
            }
        } controls: {
            VStack {
                LabeledContent("Energy") {
                    Slider(value: $energy, in: 0...1)
                }
                Picker("Arc color", selection: $palette) {
                    Text("Blue").tag(0)
                    Text("Violet").tag(1)
                }
                .pickerStyle(.segmented)
            }
        }
    }
}

#Preview {
    ElectricArcDemoView()
        .padding()
}
