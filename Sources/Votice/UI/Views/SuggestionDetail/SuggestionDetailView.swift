//
//  SuggestionDetailView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct SuggestionDetailView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.voticeTheme) private var theme

    @StateObject private var viewModel = SuggestionDetailViewModel()

    @State private var showingAddComment = false

    @FocusState private var isCommentFocused: Bool

    // MARK: - Private computed property

    private var currentSuggestion: SuggestionEntity {
        viewModel.suggestionEntity ?? suggestion
    }

    let suggestion: SuggestionEntity
    let onSuggestionUpdated: (SuggestionEntity) -> Void
    let onReload: () -> Void

    // MARK: - View

    var body: some View {
        NavigationView {
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
                if viewModel.isLoadingComments && viewModel.comments.isEmpty {
                    LoadingView(message: TextManager.shared.texts.loadingComments)
                } else {
                    mainContent
                }
            }
            .navigationTitle(TextManager.shared.texts.suggestionTitle)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(TextManager.shared.texts.close) {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack(spacing: theme.spacing.sm) {
                        if currentSuggestion.deviceId == DeviceManager.shared.deviceId {
                            Button(role: .destructive) {
                                HapticManager.shared.warning()

                                viewModel.showDeleteSuggestionConfirmation(for: currentSuggestion) {
                                    HapticManager.shared.heavyImpact()

                                    onReload()

                                    dismiss()
                                }
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill(theme.colors.error.opacity(0.1))
                                        .frame(width: 32, height: 32)
                                    Image(systemName: "trash.fill")
                                        .font(.system(size: 14, weight: .medium))
                                        .foregroundColor(theme.colors.error)
                                }
                            }
                        }
                    }
                }
            }
#endif
        }
        .task {
            await viewModel.loadInitialData(for: currentSuggestion)
        }
        .onDisappear {
            if viewModel.reload, let suggestionEntity = viewModel.suggestionEntity {
                onSuggestionUpdated(suggestionEntity)
            }
        }
        .sheet(isPresented: $showingAddComment) {
            addCommentSheet
        }
        .voticeAlert(
            isPresented: $viewModel.isShowingAlert,
            alert: viewModel.currentAlert ?? VoticeAlertEntity.error(message: "Unknown error")
        )
    }
}

// MARK: - Private

private extension SuggestionDetailView {
    var mainContent: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                suggestionHeaderCard
                votingAndStatsCard
                commentsSection
                Spacer(minLength: theme.spacing.xl)
            }
            .padding(theme.spacing.lg)
        }
    }

    var suggestionHeaderCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            HStack(alignment: .top) {
                StatusBadge(status: currentSuggestion.status ?? .pending)
                Spacer()
                SourceIndicator(source: currentSuggestion.source ?? .sdk)
            }
            Text(currentSuggestion.displayText)
                .font(theme.typography.title2)
                .fontWeight(.semibold)
                .foregroundColor(theme.colors.onSurface)
                .multilineTextAlignment(.leading)
            if let description = currentSuggestion.description,
               description != currentSuggestion.title {
                Text(description)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.onSurface.opacity(0.8))
                    .multilineTextAlignment(.leading)
            }
            authorInfoSection
        }
        .padding(theme.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    var authorInfoSection: some View {
        HStack {
            HStack(spacing: 6) {
                Image(systemName: currentSuggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                    .foregroundColor(theme.colors.secondary)
                    .font(.caption)
                if let nickname = currentSuggestion.nickname {
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
            if let createdAt = currentSuggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.caption2)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                    Text(date)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                }
            }
        }
    }

    var votingAndStatsCard: some View {
        HStack {
            VotingButtons(
                upvotes: max(0, currentSuggestion.voteCount ?? 0),
                downvotes: 0,
                currentVote: viewModel.currentVote,
                onVote: { voteType in
                    Task {
                        await viewModel.vote(on: currentSuggestion.id, type: voteType)
                    }
                }
            )
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                HStack(spacing: 4) {
                    Image(systemName: "hand.thumpsup.fill")
                        .font(.caption2)
                        .foregroundColor(theme.colors.primary)
                    Text("\(currentSuggestion.voteCount ?? 0) \(TextManager.shared.texts.votes)")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                HStack(spacing: 4) {
                    Image(systemName: "bubble.left.fill")
                        .font(.caption2)
                        .foregroundColor(theme.colors.accent)
                    Text("\(viewModel.comments.count) \(TextManager.shared.texts.comments)")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
            }
        }
        .padding(theme.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            HStack {
                Text(TextManager.shared.texts.commentsSection)
                    .font(theme.typography.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
                Button {
                    showingAddComment = true
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "plus.circle.fill")
                        Text(TextManager.shared.texts.addComment)
                    }
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.primary)
                }
            }
            if viewModel.comments.isEmpty && !viewModel.isLoadingComments {
                commentsEmptyState
            } else {
                commentsListView
            }
        }
    }

    var commentsEmptyState: some View {
        VStack(spacing: theme.spacing.md) {
            Image(systemName: "bubble.left")
                .font(.system(size: 40))
                .foregroundColor(theme.colors.secondary.opacity(0.5))
            Text(TextManager.shared.texts.noComments)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(theme.spacing.xl)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                        .stroke(theme.colors.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 1, dash: [5]))
                )
        )
    }

    var commentsListView: some View {
        LazyVStack(alignment: .leading, spacing: theme.spacing.md) {
            ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { index, comment in
                CommentCard(
                    comment: comment,
                    currentDeviceId: DeviceManager.shared.deviceId,
                    onDeleteConfirmation: {
                        viewModel.showDeleteCommentConfirmation(for: comment)
                    }
                )
                .onAppear {
                    if index >= viewModel.comments.count - 3 &&
                        viewModel.hasMoreComments &&
                        !viewModel.isLoadingComments {
                        Task {
                            await viewModel.loadMoreComments(for: currentSuggestion.id)
                        }
                    }
                }
            }
            if viewModel.isLoadingComments && viewModel.comments.count > 0 {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                    Text(TextManager.shared.texts.loadingMore)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                .padding(theme.spacing.lg)
                .frame(maxWidth: .infinity)
            }
        }
    }

    var addCommentSheet: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                HStack {
                    Button(TextManager.shared.texts.cancel) {
                        showingAddComment = false
                        viewModel.resetCommentForm()
                    }
                    .foregroundColor(theme.colors.secondary)
                    Spacer()
                    Text(TextManager.shared.texts.newComment)
                        .font(theme.typography.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onBackground)
                    Spacer()
                    Button(TextManager.shared.texts.post) {
                        Task {
                            await viewModel.submitComment(for: currentSuggestion.id) {
                                showingAddComment = false
                            }
                        }
                    }
                    .disabled(!viewModel.isCommentFormValid || viewModel.isSubmittingComment)
                    .foregroundColor(
                        viewModel.isCommentFormValid &&
                        !viewModel.isSubmittingComment ? theme.colors.primary :
                            theme.colors.secondary.opacity(0.5)
                    )
                }
                .padding(.horizontal, theme.spacing.lg)
                .padding(.top, theme.spacing.lg)
                ScrollView {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        VStack(alignment: .leading, spacing: theme.spacing.sm) {
                            Text(TextManager.shared.texts.yourComment)
                                .font(theme.typography.headline)
                                .foregroundColor(theme.colors.onBackground)
                            TextField(
                                TextManager.shared.texts.shareYourThoughts,
                                text: $viewModel.newComment,
                                axis: .vertical
                            )
                            .textFieldStyle(VoticeTextFieldStyle())
                            .lineLimit(3...8)
                            .focused($isCommentFocused)
                        }
                        VStack(alignment: .leading, spacing: theme.spacing.sm) {
                            Text(TextManager.shared.texts.yourNameOptional)
                                .font(theme.typography.headline)
                                .foregroundColor(theme.colors.onBackground)
                            TextField(TextManager.shared.texts.enterYourName, text: $viewModel.commentNickname)
                                .textFieldStyle(VoticeTextFieldStyle())
                        }
                        Spacer()
                    }
                    .padding(.horizontal, theme.spacing.lg)
                }
            }
        }
        .background(theme.colors.background)
        .onAppear {
            isCommentFocused = true
        }
    }
}
