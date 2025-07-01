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
        case .pending:
            return theme.colors.pending
        case .accepted:
            return theme.colors.accepted
        case .inProgress:
            return theme.colors.inProgress
        case .completed:
            return theme.colors.completed
        case .rejected:
            return theme.colors.rejected
        }
    }
    private var statusText: String {
        let texts = TextManager.shared.texts

        switch status {
        case .pending:
            return texts.pending
        case .accepted:
            return texts.accepted
        case .inProgress:
            return texts.inProgress
        case .completed:
            return texts.completed
        case .rejected:
            return texts.rejected
        }
    }

    let status: SuggestionStatusEntity

    // MARK: - View

    var body: some View {
        Text(statusText)
            .font(theme.typography.caption)
            .foregroundColor(.white)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(statusColor)
            .cornerRadius(theme.cornerRadius.sm)
    }
}
