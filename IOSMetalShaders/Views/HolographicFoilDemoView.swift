//
//  HolographicFoilDemoView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 15.11.2026.
//

import SwiftUI

struct HolographicFoilDemoView: View {
    @State private var strength = 0.75
    @State private var density = 38.0

    var body: some View {
        ShaderPreviewCard(
            "Holographic Foil",
            summary: "Drag to tilt rainbow foil over the image, like a collectible card."
        ) {
            InteractiveShaderCanvas(maxSampleOffset: CGSize(width: 2, height: 2)) { size, time, pointer in
                ShaderLibrary.holographicFoil(
                    .float2(size),
                    .float(time),
                    .float2(Float(pointer.x), Float(pointer.y)),
                    .float(Float(strength)),
                    .float(Float(density))
                )
            }
        } controls: {
            VStack {
                LabeledContent("Foil strength") {
                    Slider(value: $strength, in: 0...1)
                }
                LabeledContent("Groove density") {
                    Slider(value: $density, in: 12...80)
                }
            }
        }
    }
}

#Preview {
    HolographicFoilDemoView()
        .padding()
}
