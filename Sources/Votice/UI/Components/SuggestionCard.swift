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

    @State private var isPressed = false

    let suggestion: SuggestionEntity
    let currentVote: VoteType?
    let onVote: (VoteType) -> Void
    let onTap: () -> Void

    // MARK: - View

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .center, spacing: theme.spacing.md) {
                VStack(spacing: theme.spacing.xs) {
                    VotingButtons(upvotes: max(0, suggestion.voteCount ?? 0),
                                  downvotes: 0,
                                  currentVote: currentVote,
                                  onVote: onVote)
                }
                .padding(.trailing, theme.spacing.sm)
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack(alignment: .top, spacing: theme.spacing.sm) {
                        Text(suggestion.displayText)
                            .font(theme.typography.headline)
                            .foregroundColor(theme.colors.onSurface)
                            .multilineTextAlignment(.leading)
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                        Spacer()
                        StatusBadge(status: suggestion.status ?? .pending)
                    }
                    HStack {
                        HStack(spacing: 4) {
                            Image(systemName: suggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                                .font(.caption)
                                .foregroundColor(theme.colors.secondary)
                            if let nickname = suggestion.nickname {
                                Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                                    .font(theme.typography.caption)
                                    .foregroundColor(theme.colors.secondary)
                            } else {
                                Text(TextManager.shared.texts.suggestedAnonymously)
                                    .font(theme.typography.caption)
                                    .foregroundColor(theme.colors.secondary)
                            }
                        }
                        Spacer()
                        HStack(spacing: theme.spacing.sm) {
                            if suggestion.commentCount ?? 0 > 0 {
                                HStack(spacing: 4) {
                                    Image(systemName: "bubble.left.fill")
                                        .font(.caption)
                                        .foregroundColor(theme.colors.accent)
                                    Text("\(suggestion.commentCount ?? 0)")
                                        .font(theme.typography.caption)
                                        .foregroundColor(theme.colors.accent)
                                }
                            }
                            SourceIndicator(source: suggestion.source ?? .sdk)
                        }
                    }
                    if let createdAt = suggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                        HStack {
                            Image(systemName: "clock")
                                .font(.caption2)
                                .foregroundColor(theme.colors.secondary.opacity(0.7))
                            Text(date)
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.secondary.opacity(0.7))
                            Spacer()
                        }
                    }
                }
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(theme.colors.secondary.opacity(0.5))
                    .scaleEffect(isPressed ? 1.2 : 1.0)
            }
            .padding(theme.spacing.lg)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .fill(theme.colors.surface)
                    .shadow(
                        color: theme.colors.primary.opacity(isPressed ? 0.2 : 0.08),
                        radius: isPressed ? 12 : 6,
                        x: 0,
                        y: isPressed ? 6 : 3
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .stroke(
                        LinearGradient(
                            colors: [
                                theme.colors.primary.opacity(isPressed ? 0.3 : 0.1),
                                theme.colors.accent.opacity(isPressed ? 0.2 : 0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: isPressed ? 2 : 1
                    )
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        } perform: {
            onTap()
        }
    }
}
