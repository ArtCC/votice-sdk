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
            .fontWeight(.medium)
            .lineLimit(1)
            .foregroundColor(isSelected ? .white : theme.colors.onBackground)
            .padding(.vertical, 10)
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .fill(.clear)
                    .shadow(
                        color: .black.opacity(0.1),
                        radius: isFocused ? 12 : 4,
                        x: 0,
                        y: isFocused ? 6 : 2
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .stroke(borderColor, lineWidth: isFocused ? 4 : (isSelected ? 2 : 0))
            )
            .scaleEffect(isFocused ? 1.05 : 1.0)
            .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

// MARK: - Private

private extension TVOSSegmentButton {
    var textColor: Color {
        if isSelected {
            return .white
        } else if isFocused {
            return theme.colors.primary
        } else {
            return theme.colors.onSurface
        }
    }

    var backgroundColor: Color {
        if isSelected {
            return theme.colors.primary
        } else {
            return theme.colors.surface
        }
    }

    var borderColor: Color {
        if isFocused {
            return theme.colors.primary.opacity(0.6)
        } else if isSelected {
            return theme.colors.primary.opacity(0.3)
        } else {
            return Color.clear
        }
    }
}
