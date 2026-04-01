//
//  ShaderSortOrder.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

enum ShaderSortOrder: CaseIterable, Identifiable {
    case newest
    case category

    var id: Self { self }

    var title: String {
        switch self {
        case .newest:
            "Newest First"
        case .category:
            "By Category"
        }
    }

    var systemImage: String {
        switch self {
        case .newest:
            "clock.arrow.circlepath"
        case .category:
            "square.grid.2x2"
        }
    }
}
