//
//  ShaderDemoList.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

struct ShaderDemoList: View {
    let sortOrder: ShaderSortOrder

    var body: some View {
        switch sortOrder {
        case .newest:
            ForEach(ShaderDemo.allCases.reversed()) { shader in
                shader.content
            }

        case .category:
            ForEach(ShaderCategory.allCases) { category in
                Section {
                    ForEach(shaders(in: category)) { shader in
                        shader.content
                    }
                } header: {
                    ShaderCategoryHeader(category: category)
                }
            }
        }
    }

    private func shaders(in category: ShaderCategory) -> [ShaderDemo] {
        ShaderDemo.allCases.reversed().filter { $0.category == category }
    }
}
