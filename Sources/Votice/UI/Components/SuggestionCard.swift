//
//  SuggestionCard.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Suggestion Card

struct SuggestionCard: View {
    @Environment(\.voticeTheme) private var theme

    let suggestion: SuggestionEntity
    let currentVote: VoteType?
    let onVote: (VoteType) -> Void
    let onTap: () -> Void

    private var statusColor: Color {
        switch suggestion.status {
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
        switch suggestion.status {
        case .pending:
            return "Pending"
        case .accepted:
            return "Accepted"
        case .inProgress:
            return "In Progress"
        case .completed:
            return "Completed"
        case .rejected:
            return "Rejected"
        }
    }

    var body: some View {
        Button(action: onTap) {
            HStack(alignment: .top, spacing: theme.spacing.md) {
                // Voting Section
                VotingButtons(
                    upvotes: max(0, suggestion.voteCount),
                    downvotes: 0, // Backend doesn't separate upvotes/downvotes yet
                    currentVote: currentVote,
                    onVote: onVote
                )

                // Content Section
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    // Title/Text
                    Text(suggestion.displayText)
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onSurface)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)

                    // Metadata Row
                    HStack {
                        // Status Badge
                        StatusBadge(status: suggestion.status, color: statusColor)

                        Spacer()

                        // Comment Count
                        if suggestion.commentCount > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "bubble.left")
                                    .font(.caption)
                                Text("\(suggestion.commentCount)")
                                    .font(theme.typography.caption)
                            }
                            .foregroundColor(theme.colors.secondary)
                        }

                        // Source Indicator
                        SourceIndicator(source: suggestion.source)
                    }

                    // Author & Date
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

                        Text(formatDate(suggestion.createdAt))
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.secondary)
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

    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    @Environment(\.voticeTheme) private var theme

    let status: SuggestionStatus
    let color: Color

    private var statusText: String {
        switch status {
        case .pending: return "Pending"
        case .accepted: return "Accepted"
        case .inProgress: return "In Progress"
        case .completed: return "Completed"
        case .rejected: return "Rejected"
        }
    }

    var body: some View {
        Text(statusText)
            .font(theme.typography.caption)
            .foregroundColor(.white)
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(color)
            .cornerRadius(theme.cornerRadius.sm)
    }
}

// MARK: - Source Indicator

private struct SourceIndicator: View {
    @Environment(\.voticeTheme) private var theme

    let source: SuggestionSource

    private var icon: String {
        switch source {
        case .dashboard: return "desktopcomputer"
        case .sdk: return "iphone"
        }
    }

    var body: some View {
        Image(systemName: icon)
            .font(.caption)
            .foregroundColor(theme.colors.secondary)
    }
}

// MARK: - Preview

#Preview {
    let sampleSuggestion = SuggestionEntity(
        id: "1",
        appId: "app1",
        title: "Dark Mode Support",
        text: "Please add dark mode support to improve user experience in low light conditions",
        description: nil,
        status: .pending,
        voteCount: 15,
        commentCount: 3,
        source: .sdk,
        createdBy: "device123",
        deviceId: "device123",
        nickname: "John Doe",
        platform: "iOS",
        language: "en",
        createdAt: Date().addingTimeInterval(-3600),
        updatedAt: Date().addingTimeInterval(-3600)
    )

    VStack(spacing: 16) {
        SuggestionCard(
            suggestion: sampleSuggestion,
            currentVote: .upvote,
            onVote: { _ in },
            onTap: {}
        )

        SuggestionCard(
            suggestion: SuggestionEntity(
                id: "2",
                appId: "app1",
                title: nil,
                text: "Add widgets support",
                description: nil,
                status: .completed,
                voteCount: 8,
                commentCount: 0,
                source: .dashboard,
                createdBy: "user456",
                deviceId: nil,
                nickname: nil,
                platform: nil,
                language: nil,
                createdAt: Date().addingTimeInterval(-86400),
                updatedAt: Date().addingTimeInterval(-3600)
            ),
            currentVote: nil,
            onVote: { _ in },
            onTap: {}
        )
    }
    .padding()
}
