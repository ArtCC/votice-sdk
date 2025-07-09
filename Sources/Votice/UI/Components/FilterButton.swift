//
//  FilterButton.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct FilterButton: View {
    // MARK: - Properties

    let title: String
    let isSelected: Bool
    let action: () -> Void

    // MARK: - View

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
