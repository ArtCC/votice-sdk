//
//  SuggestionDetailView+tvOS.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/10/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - tvOS

#if os(tvOS)
extension SuggestionDetailView {
    var tvOSView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                tvOSHeaderSection
                if let issue = currentSuggestion.issue,
                   let urlImage = currentSuggestion.urlImage,
                   issue,
                   !urlImage.isEmpty {
                    tvOSImageCard
                }
                tvOSStatsCard
                if ConfigurationManager.shared.commentIsEnabled {
                    tvOSCommentsSection
                }
                Spacer()
            }
            .padding(40)
        }
        .background(
            LinearGradient(
                colors: [
                    theme.colors.background,
                    theme.colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
        )
        .task {
            await viewModel.loadInitialData(for: currentSuggestion)
        }
    }

    var tvOSHeaderSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack(alignment: .top, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack(spacing: 8) {
                        if let issue = suggestion.issue, issue {
                            Image(systemName: "ladybug.fill")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(theme.colors.pending)
                        }
                        Text(currentSuggestion.displayText)
                            .font(theme.typography.title2)
                            .foregroundColor(theme.colors.onSurface)
                            .multilineTextAlignment(.leading)
                        Spacer()
                        StatusBadge(status: currentSuggestion.status ?? .pending, useLiquidGlass: false)
                    }
                    if let description = currentSuggestion.description, description != currentSuggestion.title {
                        Text(description)
                            .font(theme.typography.body)
                            .foregroundColor(theme.colors.onSurface.opacity(0.7))
                            .multilineTextAlignment(.leading)
                            .padding(.top, theme.spacing.sm)
                    }
                }
            }
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                HStack(spacing: 10) {
                    Image(systemName: currentSuggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                        .font(.system(size: 18))
                    if let nickname = currentSuggestion.nickname {
                        Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                            .font(theme.typography.subheadline)
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    } else {
                        Text(TextManager.shared.texts.suggestedAnonymously)
                            .font(theme.typography.subheadline)
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    }
                }
                if let createdAt = currentSuggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 18))
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                        Text(date)
                            .font(theme.typography.subheadline)
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    }
                }
            }
            .padding(.top, theme.spacing.md)
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    var tvOSImageCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            HStack(spacing: theme.spacing.md) {
                Image(systemName: "photo")
                    .foregroundColor(theme.colors.primary)
                    .font(.system(size: 22, weight: .semibold))
                Text(TextManager.shared.texts.titleIssueImage)
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onSurface)
                    .multilineTextAlignment(.leading)
                Spacer()
            }
            HStack {
                AsyncImage(url: URL(string: currentSuggestion.urlImage ?? "")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxHeight: 350)
                        .cornerRadius(theme.cornerRadius.lg)
                } placeholder: {
                    RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                        .fill(theme.colors.secondary.opacity(0.1))
                        .frame(height: 300)
                        .overlay(
                            VStack(spacing: theme.spacing.md) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                                Text(TextManager.shared.texts.loadingImage)
                                    .font(.system(size: 22))
                                    .foregroundColor(theme.colors.secondary)
                            }
                        )
                }
                Spacer()
            }
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    var tvOSStatsCard: some View {
        HStack(spacing: 60) {
            VStack(spacing: theme.spacing.md) {
                Image(systemName: "hand.thumbsup.fill")
                    .font(.system(size: 26))
                    .foregroundColor(theme.colors.primary)
                Text("\(max(0, currentSuggestion.voteCount ?? 0))")
                    .font(theme.typography.title)
                    .foregroundColor(theme.colors.onSurface)

                Text(TextManager.shared.texts.votes)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
            }
            .frame(maxWidth: .infinity)
            if ConfigurationManager.shared.commentIsEnabled {
                Divider()
                    .frame(height: 80)
                VStack(spacing: theme.spacing.md) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 26))
                        .foregroundColor(theme.colors.accent)
                    Text("\(viewModel.comments.count)")
                        .font(theme.typography.title)
                        .foregroundColor(theme.colors.onSurface)
                    Text(TextManager.shared.texts.comments)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    var tvOSCommentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            Text(TextManager.shared.texts.commentsSection)
                .font(theme.typography.title)
                .foregroundColor(theme.colors.onBackground)
                .padding(.horizontal, 40)
            if viewModel.isLoadingComments && viewModel.comments.isEmpty {
                tvOSCommentsLoadingView
            } else if viewModel.comments.isEmpty && !viewModel.isLoadingComments {
                tvOSCommentsEmptyState
            } else {
                tvOSCommentsList
            }
        }
    }

    var tvOSCommentsLoadingView: some View {
        VStack(spacing: theme.spacing.lg) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
            Text(TextManager.shared.texts.loadingComments)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
        .padding(60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    var tvOSCommentsEmptyState: some View {
        VStack(spacing: theme.spacing.xl) {
            Image(systemName: "bubble.left")
                .font(.system(size: 60))
                .foregroundColor(theme.colors.secondary.opacity(0.5))
            Text(TextManager.shared.texts.noComments)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(60)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                        .stroke(theme.colors.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 2, dash: [10]))
                )
        )
    }

    var tvOSCommentsList: some View {
        LazyVStack(spacing: theme.spacing.lg) {
            ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { index, comment in
                tvOSCommentCard(comment: comment)
                    .onAppear {
                        if index >= viewModel.comments.count - 3 &&
                            viewModel.hasMoreComments &&
                            !viewModel.isLoadingPaginationComments {
                            Task {
                                await viewModel.loadMoreComments(for: currentSuggestion.id)
                            }
                        }
                    }
            }
            if viewModel.isLoadingPaginationComments && viewModel.comments.count > 0 {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                    .padding(40)
            }
        }
    }

    func tvOSCommentCard(comment: CommentEntity) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                    Text(comment.displayName)
                        .font(theme.typography.subheadline)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                    Spacer()
                }
                Spacer()
                if let createdAt = comment.createdAt, let date = Date.formatFromISOString(createdAt) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 18))
                            .foregroundColor(theme.colors.secondary.opacity(0.6))
                        Text(date)
                            .font(theme.typography.subheadline)
                            .foregroundColor(theme.colors.secondary.opacity(0.6))
                    }
                }
            }
            Text(comment.text)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.onSurface)
                .multilineTextAlignment(.leading)
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
        )
    }
}
#endif
