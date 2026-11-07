//
//  ShaderDemoList.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

struct ShaderDemoList: View {
    let sortOrder: ShaderSortOrder
    let searchText: String

    private var searchQuery: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var matchingShaders: [ShaderDemo] {
        let query = searchQuery
        return ShaderDemo.allCases.reversed().filter {
            query.isEmpty || $0.name.localizedStandardContains(query)
        }
    }

    var body: some View {
        let shaders = matchingShaders

        if shaders.isEmpty {
            ContentUnavailableView.search(text: searchQuery)
                .frame(maxWidth: .infinity)
        } else {
            switch sortOrder {
            case .newest:
                ForEach(shaders) { shader in
                    shader.content
                }

            case .category:
                let groupedShaders = Dictionary(grouping: shaders, by: \.category)

                ForEach(ShaderCategory.allCases) { category in
                    if let categoryShaders = groupedShaders[category] {
                        Section {
                            ForEach(categoryShaders) { shader in
                                shader.content
                            }
                        } header: {
                            ShaderCategoryHeader(category: category)
                        }
                    }
                }
            }
        }
    }
}
