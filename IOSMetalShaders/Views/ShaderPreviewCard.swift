//
//  ShaderPreviewCard.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 26.12.2025.
//

import SwiftUI

struct ShaderPreviewCard<Preview: View, Controls: View>: View {
    let title: LocalizedStringKey
    let summary: LocalizedStringKey

    private let preview: Preview
    private let controls: Controls

    init(
        _ title: LocalizedStringKey,
        summary: LocalizedStringKey,
        @ViewBuilder preview: () -> Preview,
        @ViewBuilder controls: () -> Controls
    ) {
        self.title = title
        self.summary = summary
        self.preview = preview()
        self.controls = controls()
    }

    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.title3)
                    .bold()

                Text(summary)
                    .foregroundStyle(.secondary)
            }

            preview
            controls
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(.rect(cornerRadius: AppTheme.cornerRadius))
    }
}
