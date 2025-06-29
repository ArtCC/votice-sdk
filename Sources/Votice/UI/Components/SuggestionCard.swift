//
//  SuggestionCard.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct SuggestionCard: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    let suggestion: SuggestionEntity
    let currentVote: VoteType?
    let onVote: (VoteType) -> Void
    let onTap: () -> Void

    // MARK: - View

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: theme.spacing.md) {
                VotingButtons(upvotes: max(0, suggestion.voteCount ?? 0),
                    downvotes: 0,
                    currentVote: currentVote,
                    onVote: onVote)
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text(suggestion.displayText)
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onSurface)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                    HStack {
                        StatusBadge(status: suggestion.status ?? .pending)
                        Spacer()
                        if suggestion.commentCount ?? 0 > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left")
                                    .font(.caption)
                                Text("\(suggestion.commentCount)")
                                    .font(theme.typography.caption)
                            }
                            .foregroundColor(theme.colors.secondary)
                        }
                        SourceIndicator(source: suggestion.source ?? .sdk)
                    }
                    HStack {
                        if let nickname = suggestion.nickname {
                            Text("by \(nickname)")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.secondary)
                        } else {
                            Text("by Anonymous")
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.secondary)
                        }
                        Spacer()
                        if let createdAt = suggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                            Text(date)
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.secondary)
                        }
                    }
                }
                Spacer()
            }
            .padding(theme.spacing.md)
            .background(theme.colors.surface)
            .cornerRadius(theme.cornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .stroke(theme.colors.secondary.opacity(0.2), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
