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
        ZStack {
            LinearGradient(
                colors: [
                    theme.colors.background,
                    theme.colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            ScrollView(showsIndicators: true) {
                VStack(alignment: .leading, spacing: theme.spacing.xxxl) {
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
                    Spacer(minLength: theme.spacing.xxxl)
                }
                .padding(.horizontal, 60)
                .padding(.vertical, 40)
            }
        }
        .task {
            await viewModel.loadInitialData(for: currentSuggestion)
        }
    }

    var tvOSHeaderSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            HStack(alignment: .top, spacing: theme.spacing.lg) {
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    HStack(spacing: 8) {
                        if let issue = suggestion.issue, issue {
                            Image(systemName: "ladybug.fill")
                                .font(.system(size: 28, weight: .semibold))
                                .foregroundColor(theme.colors.pending)
                        }
                        Text(currentSuggestion.displayText)
                            .font(.system(size: 42, weight: .bold))
                            .foregroundColor(theme.colors.onSurface)
                            .multilineTextAlignment(.leading)
                    }
                    if let description = currentSuggestion.description, description != currentSuggestion.title {
                        Text(description)
                            .font(.system(size: 28))
                            .foregroundColor(theme.colors.onSurface.opacity(0.8))
                            .multilineTextAlignment(.leading)
                            .padding(.top, theme.spacing.sm)
                    }
                }
                Spacer()
                StatusBadge(status: currentSuggestion.status ?? .pending, useLiquidGlass: false)
                    .scaleEffect(1.5)
            }
            VStack(alignment: .leading, spacing: theme.spacing.md) {
                HStack(spacing: 10) {
                    Image(systemName: currentSuggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                        .font(.system(size: 24))
                    if let nickname = currentSuggestion.nickname {
                        Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                            .font(.system(size: 24))
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    } else {
                        Text(TextManager.shared.texts.suggestedAnonymously)
                            .font(.system(size: 24))
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    }
                }
                if let createdAt = currentSuggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 24))
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                        Text(date)
                            .font(.system(size: 24))
                            .foregroundColor(theme.colors.secondary.opacity(0.7))
                    }
                }
            }
            .padding(.top, theme.spacing.md)
        }
        .padding(40)
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
                    .font(.system(size: 32, weight: .semibold))
                Text(TextManager.shared.texts.titleIssueImage)
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
            }
            AsyncImage(url: URL(string: currentSuggestion.urlImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 800)
                    .cornerRadius(theme.cornerRadius.lg)
            } placeholder: {
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .fill(theme.colors.secondary.opacity(0.1))
                    .frame(height: 400)
                    .overlay(
                        VStack(spacing: theme.spacing.md) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                                .scaleEffect(1.5)
                            Text(TextManager.shared.texts.loadingImage)
                                .font(.system(size: 24))
                                .foregroundColor(theme.colors.secondary)
                        }
                    )
            }
        }
        .padding(40)
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
                    .font(.system(size: 48))
                    .foregroundColor(theme.colors.primary)

                Text("\(max(0, currentSuggestion.voteCount ?? 0))")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundColor(theme.colors.onSurface)

                Text(TextManager.shared.texts.votes)
                    .font(.system(size: 24))
                    .foregroundColor(theme.colors.secondary)
            }
            .frame(maxWidth: .infinity)
            if ConfigurationManager.shared.commentIsEnabled {
                Divider()
                    .frame(height: 120)
                VStack(spacing: theme.spacing.md) {
                    Image(systemName: "bubble.left.fill")
                        .font(.system(size: 48))
                        .foregroundColor(theme.colors.accent)
                    Text("\(viewModel.comments.count)")
                        .font(.system(size: 56, weight: .bold))
                        .foregroundColor(theme.colors.onSurface)
                    Text(TextManager.shared.texts.comments)
                        .font(.system(size: 24))
                        .foregroundColor(theme.colors.secondary)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.xl)
                .fill(theme.colors.surface)
                .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
        )
    }

    var tvOSCommentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            Text(TextManager.shared.texts.commentsSection)
                .font(.system(size: 36, weight: .semibold))
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
                .scaleEffect(1.5)
            Text(TextManager.shared.texts.loadingComments)
                .font(.system(size: 24))
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
                .font(.system(size: 80))
                .foregroundColor(theme.colors.secondary.opacity(0.5))
            Text(TextManager.shared.texts.noComments)
                .font(.system(size: 28))
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
                    .scaleEffect(1.5)
                    .padding(40)
            }
        }
    }

    func tvOSCommentCard(comment: CommentEntity) -> some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                HStack(spacing: 10) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                    Text(comment.displayName)
                        .font(.system(size: 24))
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                }
                Spacer()
                if let createdAt = comment.createdAt, let date = Date.formatFromISOString(createdAt) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock")
                            .font(.system(size: 20))
                            .foregroundColor(theme.colors.secondary.opacity(0.6))
                        Text(date)
                            .font(.system(size: 20))
                            .foregroundColor(theme.colors.secondary.opacity(0.6))
                    }
                }
            }
            Text(comment.text)
                .font(.system(size: 28))
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
