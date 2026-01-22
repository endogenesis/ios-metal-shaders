//
//  ShaderCanvasView.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct ShaderCanvasView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.indigo, .cyan, .orange],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Image(systemName: "swift")
                .font(.system(size: 76))
                .bold()
                .foregroundStyle(.white)

            VStack {
                Spacer()

                Text("METAL")
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(16 / 10, contentMode: .fit)
        .clipShape(.rect(cornerRadius: AppTheme.previewCornerRadius))
    }
}
