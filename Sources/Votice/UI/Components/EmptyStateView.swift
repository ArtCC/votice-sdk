//
//  EmptyStateView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    // MARK: - View

    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            Image(systemName: "lightbulb")
                .font(.system(size: 64))
                .foregroundColor(theme.colors.secondary)
            VStack(spacing: theme.spacing.sm) {
                Text("No suggestions yet")
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onBackground)
                Text("Be the first to suggest a new feature!")
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(theme.spacing.xl)
    }
}
