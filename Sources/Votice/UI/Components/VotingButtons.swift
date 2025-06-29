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
    @State private var showHeartAnimation = false

    private var hasVoted: Bool {
        currentVote != nil
    }

    private var voteColor: Color {
        hasVoted ? theme.colors.primary : theme.colors.secondary.opacity(0.6)
    }

    var body: some View {
        VStack(spacing: theme.spacing.xs) {
            Button(action: handleVote) {
                VStack(spacing: 4) {
                    ZStack {
                        // Main thumbs up icon
                        Image(systemName: hasVoted ? "hand.thumbsup.fill" : "hand.thumbsup")
                            .font(.title2)
                            .foregroundColor(voteColor)
                            .scaleEffect(isAnimating ? 1.3 : 1.0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isAnimating)

                        // Heart animation for vote
                        if showHeartAnimation {
                            Image(systemName: "heart.fill")
                                .font(.caption)
                                .foregroundColor(.red)
                                .offset(y: -20)
                                .opacity(showHeartAnimation ? 0 : 1)
                                .scaleEffect(showHeartAnimation ? 1.5 : 0.5)
                                .animation(.easeOut(duration: 0.8), value: showHeartAnimation)
                        }
                    }

                    Text("\(upvotes)")
                        .font(theme.typography.caption)
                        .foregroundColor(voteColor)
                        .fontWeight(hasVoted ? .semibold : .regular)
                }
            }
            .buttonStyle(PlainButtonStyle())
            .scaleEffect(isAnimating ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isAnimating)
        }
        .frame(minWidth: 44, minHeight: 44)
    }

    private func handleVote() {
        // Trigger button press animation
        withAnimation(.easeInOut(duration: 0.1)) {
            isAnimating = true
        }

        // Reset animation after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            withAnimation(.easeInOut(duration: 0.1)) {
                isAnimating = false
            }
        }

        if hasVoted {
            // User wants to unvote - we'll use the same vote type to toggle it off
            onVote(currentVote!)
        } else {
            // User wants to vote - always use upvote since we only have one button
            onVote(.upvote)

            // Show heart animation for new votes
            withAnimation(.easeOut(duration: 0.8)) {
                showHeartAnimation = true
            }

            // Reset heart animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                showHeartAnimation = false
            }
        }
    }
}
