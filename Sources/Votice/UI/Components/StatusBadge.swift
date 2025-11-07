//
//  StatusBadge.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct StatusBadge: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    private var statusColor: Color {
        switch status {
        case .accepted:
            return theme.colors.accepted
        case .blocked:
            return theme.colors.rejected
        case .completed:
            return theme.colors.completed
        case .inProgress:
            return theme.colors.inProgress
        case .pending:
            return theme.colors.pending
        case .rejected:
            return theme.colors.rejected
        }
    }
    private var statusText: String {
        let texts = TextManager.shared.texts

        switch status {
        case .accepted:
            return texts.accepted
        case .blocked:
            return texts.blocked
        case .completed:
            return texts.completed
        case .inProgress:
            return texts.inProgress
        case .pending:
            return texts.pending
        case .rejected:
            return texts.rejected
        }
    }

    let status: SuggestionStatusEntity
    let progress: Int?
    let useLiquidGlass: Bool

    // MARK: - View

    var body: some View {
        Text(statusText)
            .font(theme.typography.caption)
            .foregroundColor(.white)
            .padding(.vertical, theme.spacing.xs)
            .padding(.horizontal, theme.spacing.sm)
            .adaptiveGlassBackground(
                useLiquidGlass: useLiquidGlass,
                cornerRadius: theme.cornerRadius.sm,
                fillColor: statusColor
            )
    }
}
