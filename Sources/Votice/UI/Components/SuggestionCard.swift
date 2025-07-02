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
            ZStack(alignment: .topTrailing) {
                HStack(alignment: .center, spacing: theme.spacing.md) {
                    VStack(spacing: theme.spacing.sm) {
                        VotingButtons(upvotes: max(0, suggestion.voteCount ?? 0),
                                      downvotes: 0,
                                      currentVote: currentVote,
                                      onVote: onVote)
                        if suggestion.commentCount ?? 0 > 0 {
                            VStack(spacing: 4) {
                                Image(systemName: "bubble.left.fill")
                                    .font(.subheadline)
                                    .foregroundColor(theme.colors.accent)
                                Text("\(suggestion.commentCount ?? 0)")
                                    .font(theme.typography.body)
                                    .foregroundColor(theme.colors.accent)
                            }
                        }
                    }
                    VStack(alignment: .leading, spacing: theme.spacing.sm) {
                        titleView
                        authorView
                        createdAtView
                    }
                    .padding(.trailing, theme.spacing.md)
                    Image(systemName: "chevron.right")
                        .font(.caption)
                        .foregroundColor(theme.colors.secondary.opacity(0.5))
                        .scaleEffect(isPressed ? 1.2 : 1.0)
                }
                .padding(theme.spacing.md)
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
                StatusBadge(status: suggestion.status ?? .pending)
                    .padding(theme.spacing.sm)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0) { pressing in
            withAnimation(.easeInOut(duration: 0.15)) {
                isPressed = pressing
            }
        } perform: {
            HapticManager.shared.lightImpact()

            onTap()
        }
    }
}

// MARK: - Private

private extension SuggestionCard {
    var titleView: some View {
        VStack(spacing: theme.spacing.sm) {
            HStack {
                Text(suggestion.displayText)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onSurface)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                Spacer()
            }
            if let description = suggestion.description {
                HStack {
                    Text(description)
                        .font(theme.typography.callout)
                        .foregroundColor(theme.colors.onSurface.opacity(0.7))
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
            }
        }
    }

    var authorView: some View {
        HStack {
            HStack(spacing: 4) {
                Image(systemName: suggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                    .font(.subheadline)
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                if let nickname = suggestion.nickname {
                    Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                        .font(theme.typography.subheadline)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                } else {
                    Text(TextManager.shared.texts.suggestedAnonymously)
                        .font(theme.typography.subheadline)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                }
            }
            Spacer()
        }
    }

    @ViewBuilder
    var createdAtView: some View {
        if let createdAt = suggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
            HStack {
                Image(systemName: "clock")
                    .font(.subheadline)
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                Text(date)
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                Spacer()
            }
        }
    }
}
