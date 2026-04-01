//
//  ShaderCategoryHeader.swift
//  IOSMetalShaders
//
//  Created by Mikalai Tsyhankou on 01.04.2026.
//

import SwiftUI

struct ShaderCategoryHeader: View {
    let category: ShaderCategory

    var body: some View {
        Text(category.rawValue)
            .font(.title2)
            .bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 8)
            .background(.background)
    }
}
