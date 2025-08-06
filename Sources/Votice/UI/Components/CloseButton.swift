//
//  CloseButton.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 6/8/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct CloseButton: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    let isNavigation: Bool
    let onClose: () -> Void

    // MARK: - View

    var body: some View {
        Button {
            onClose()
        } label: {
            Image(systemName: isNavigation ? "chevron.left" : "xmark")
                .font(.system(size: 23.5, weight: .medium))
                .foregroundColor(theme.colors.primary)
                .padding(.horizontal, theme.spacing.sm)
                .padding(.vertical, theme.spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                        .fill(theme.colors.primary.opacity(0.1))
                )
        }
        .buttonStyle(.plain)
    }
}
