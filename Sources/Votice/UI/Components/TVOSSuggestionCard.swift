//
//  TVOSSuggestionCard.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 8/10/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct TVOSSuggestionCard: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme
    @Environment(\.isFocused) private var isFocused

    private var hasVoted: Bool {
        currentVote != nil
    }
    private var voteColor: Color {
        hasVoted ? theme.colors.primary : theme.colors.secondary.opacity(0.6)
    }

    let suggestion: SuggestionEntity
    let currentVote: VoteType?

    // MARK: - View

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(spacing: 12.5) {
                VStack(spacing: 5) {
                    Image(systemName: hasVoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(theme.typography.subheadline)
                        .foregroundColor(voteColor)
                    Text("\(max(0, suggestion.voteCount ?? 0))")
                        .font(theme.typography.body)
                        .foregroundColor(hasVoted ? theme.colors.primary : theme.colors.onSurface)
                }
                .padding(.horizontal, 12)
                .background(
                    RoundedRectangle(cornerRadius: 6)
                        .fill(hasVoted ? theme.colors.primary.opacity(0.15) : theme.colors.surface.opacity(0.5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(hasVoted ? theme.colors.primary.opacity(0.2) : Color.clear, lineWidth: 1)
                )
                if ConfigurationManager.shared.commentIsEnabled, suggestion.commentCount ?? 0 > 0 {
                    VStack(spacing: 4) {
                        Image(systemName: "bubble.left.fill")
                            .font(theme.typography.subheadline)
                            .foregroundColor(theme.colors.accent)
                        Text("\(suggestion.commentCount ?? 0)")
                            .font(theme.typography.body)
                            .fontWeight(.medium)
                            .foregroundColor(theme.colors.accent)
                    }
                }
            }
            .frame(minWidth: 80)
            VStack(alignment: .leading, spacing: 12.5) {
                titleView
                HStack {
                    authorView
                    Spacer()
                    createdAtView
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                StatusBadge(status: suggestion.status ?? .pending, useLiquidGlass: false)
                Spacer()
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(theme.colors.surface)
                .shadow(
                    color: isFocused ? .black.opacity(0.2) : .black.opacity(0.1),
                    radius: isFocused ? 12 : 4,
                    x: 0,
                    y: isFocused ? 6 : 2
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(
                    isFocused ? theme.colors.primary.opacity(0.4) : Color.clear,
                    lineWidth: isFocused ? 2 : 0
                )
        )
        .scaleEffect(isFocused ? 1.05 : 1.0)
        .animation(.easeInOut(duration: 0.15), value: isFocused)
    }
}

// MARK: - Private

private extension TVOSSuggestionCard {
    var titleView: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 8) {
                if let issue = suggestion.issue, issue {
                    Image(systemName: "ladybug.fill")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(theme.colors.pending)
                }
                Text(suggestion.displayText)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onSurface)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            if let description = suggestion.description {
                Text(description)
                    .font(theme.typography.callout)
                    .foregroundColor(theme.colors.onSurface.opacity(0.8))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    var authorView: some View {
        HStack(spacing: 5) {
            Image(systemName: suggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                .font(.system(size: 16))
                .foregroundColor(theme.colors.secondary)
            if let nickname = suggestion.nickname {
                Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.secondary)
            } else {
                Text(TextManager.shared.texts.suggestedAnonymously)
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    @ViewBuilder
    var createdAtView: some View {
        if let createdAt = suggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
            HStack(spacing: 5) {
                Image(systemName: "clock")
                    .font(.system(size: 16))
                    .foregroundColor(theme.colors.secondary)
                Text(date)
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}
