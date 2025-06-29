//
//  VotingButtons.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Voting Buttons

struct VotingButtons: View {
    @Environment(\.voticeTheme) private var theme

    let upvotes: Int
    let downvotes: Int
    let currentVote: VoteType?
    let onVote: (VoteType) -> Void

    @State private var isAnimating = false

    var body: some View {
        VStack(spacing: theme.spacing.xs) {
            // Upvote Button
            VoteButton(
                type: .upvote,
                count: upvotes,
                isSelected: currentVote == .upvote,
                onTap: { onVote(.upvote) }
            )

            // Downvote Button
            VoteButton(
                type: .downvote,
                count: downvotes,
                isSelected: currentVote == .downvote,
                onTap: { onVote(.downvote) }
            )
        }
    }
}

// MARK: - Vote Button

private struct VoteButton: View {
    @Environment(\.voticeTheme) private var theme

    let type: VoteType
    let count: Int
    let isSelected: Bool
    let onTap: () -> Void

    @State private var isPressed = false

    private var color: Color {
        switch type {
        case .upvote:
            return isSelected ? theme.colors.upvote : theme.colors.secondary
        case .downvote:
            return isSelected ? theme.colors.downvote : theme.colors.secondary
        }
    }

    private var icon: String {
        switch type {
        case .upvote:
            return isSelected ? "arrow.up.circle.fill" : "arrow.up.circle"
        case .downvote:
            return isSelected ? "arrow.down.circle.fill" : "arrow.down.circle"
        }
    }

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)

                Text("\(count)")
                    .font(theme.typography.caption)
                    .foregroundColor(color)
            }
        }
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.1)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}
