//
//  TVOSSegmentButton.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 8/10/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct TVOSSegmentButton: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme
    @Environment(\.isFocused) private var isFocused

    let title: String
    let isSelected: Bool

    // MARK: - View

    var body: some View {
        Text(title)
            .font(theme.typography.callout)
            .lineLimit(1)
            .foregroundColor(textColor)
            .padding(.vertical, 10)
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .fill(backgroundColor)
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: isFocused ? 12 : 4,
                        x: 0,
                        y: isFocused ? 6 : 2
                    )
            )
    }
}

// MARK: - Private

private extension TVOSSegmentButton {
    var textColor: Color {
        if isSelected {
            return .white
        } else if isFocused {
            return .white
        } else {
            return theme.colors.onSurface
        }
    }

    var backgroundColor: Color {
        if isSelected {
            return theme.colors.primary
        } else if isFocused {
            return theme.colors.primary.opacity(0.35)
        } else {
            return theme.colors.surface
        }
    }
}
