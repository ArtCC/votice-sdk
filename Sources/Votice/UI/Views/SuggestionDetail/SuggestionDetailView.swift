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
#if os(tvOS)
        VStack {
            Spacer()
            Text("Votice SDK is not available on tvOS.")
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
                .padding()
            Spacer()
        }
#else
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
            VStack(spacing: 0) {
                headerView
                mainContent
            }
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
#endif
    }
}

// MARK: - Private

private extension SuggestionDetailView {
    var headerView: some View {
        ZStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(theme.colors.secondary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(theme.colors.secondary.opacity(0.1))
                        )
                }
                .buttonStyle(.plain)
                Spacer()
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
                        .buttonStyle(.plain)
                    }
                }
            }
            HStack {
                Spacer()
                Text(TextManager.shared.texts.suggestionTitle)
                    .font(theme.typography.headline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
            }
        }
        .padding(theme.spacing.md)
        .background(
            theme.colors.background
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }

    var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                suggestionHeaderCard
                if let issue = currentSuggestion.issue,
                   let urlImage = currentSuggestion.urlImage,
                   issue,
                   !urlImage.isEmpty {
                    issueImageCard
                }
                votingAndStatsCard
                if ConfigurationManager.shared.commentIsEnabled {
                    commentsSection
                }
                Spacer(minLength: theme.spacing.xl)
            }
            .padding(theme.spacing.md)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
    }

    var suggestionHeaderCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                VStack(spacing: theme.spacing.sm) {
                    HStack(spacing: 5) {
                        if let issue = suggestion.issue, issue {
                            Image(systemName: "ladybug.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(theme.colors.pending)
                        }
                        Text(currentSuggestion.displayText)
                            .font(theme.typography.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(theme.colors.onSurface)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.top, theme.spacing.md)
                    .padding(.leading, theme.spacing.md)
                    .padding(.trailing, theme.spacing.xxxxl)
                    if let description = currentSuggestion.description, description != currentSuggestion.title {
                        HStack {
                            Text(description)
                                .font(theme.typography.callout)
                                .foregroundColor(theme.colors.onSurface.opacity(0.7))
                                .multilineTextAlignment(.leading)
                            Spacer()
                        }
                        .padding(.leading, theme.spacing.md)
                        .padding(.trailing, theme.spacing.xl)
                        .padding(.bottom, theme.spacing.md)
                    }
                }
                authorInfoSection
            }
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .fill(theme.colors.surface)
                    .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
            )
            StatusBadge(status: currentSuggestion.status ?? .pending)
                .padding(theme.spacing.sm)
        }
    }

    var authorInfoSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack(spacing: 6) {
                Image(systemName: currentSuggestion.nickname != nil ? "person.circle.fill" : "person.circle")
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                    .font(.subheadline)
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
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                        .font(.subheadline)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                    Text(date)
                        .font(theme.typography.subheadline)
                        .foregroundColor(theme.colors.secondary.opacity(0.7))
                }
            }
        }
        .padding(.horizontal, theme.spacing.md)
        .padding(.bottom, theme.spacing.md)
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
                    Image(systemName: currentSuggestion.voteCount ?? 0 > 0 ? "hand.thumbsup.fill" : "hand.thumbsup")
                        .font(.caption)
                        .foregroundColor(theme.colors.primary)
                    Text("\(currentSuggestion.voteCount ?? 0) \(TextManager.shared.texts.votes)")
                        .font(theme.typography.callout)
                        .foregroundColor(theme.colors.secondary)
                }
                if ConfigurationManager.shared.commentIsEnabled {
                    HStack(spacing: 4) {
                        Image(systemName: viewModel.comments.count > 0 ? "bubble.left.fill" : "bubble.left")
                            .font(.caption)
                            .foregroundColor(theme.colors.accent)
                        Text("\(viewModel.comments.count) \(TextManager.shared.texts.comments)")
                            .font(theme.typography.callout)
                            .foregroundColor(theme.colors.secondary)
                    }
                }
            }
        }
        .padding(theme.spacing.md)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
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
                .buttonStyle(.plain)
            }
            if viewModel.isLoadingComments && viewModel.comments.isEmpty {
                commentsLoadingView
            } else if viewModel.comments.isEmpty && !viewModel.isLoadingComments {
                commentsEmptyState
            } else {
                commentsListView
            }
        }
    }

    var commentsLoadingView: some View {
        VStack(spacing: theme.spacing.md) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
            Text(TextManager.shared.texts.loadingComments)
                .font(theme.typography.caption)
                .foregroundColor(theme.colors.secondary)
        }
        .padding(theme.spacing.md)
        .frame(maxWidth: .infinity)
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
                        !viewModel.isLoadingPaginationComments {
                        Task {
                            await viewModel.loadMoreComments(for: currentSuggestion.id)
                        }
                    }
                }
            }
            if viewModel.isLoadingPaginationComments && viewModel.comments.count > 0 {
                HStack {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                    Text(TextManager.shared.texts.loadingMore)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                .padding(theme.spacing.md)
                .frame(maxWidth: .infinity)
            }
        }
    }

    var issueImageCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Image(systemName: "photo")
                    .foregroundColor(theme.colors.primary)
                    .font(.headline)
                Text(TextManager.shared.texts.titleIssueImage)
                    .font(theme.typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
            }
            .padding(.top, theme.spacing.md)
            .padding(.horizontal, theme.spacing.md)
            AsyncImage(url: URL(string: currentSuggestion.urlImage ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxHeight: 600)
                    .cornerRadius(theme.cornerRadius.md)
            } placeholder: {
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .fill(theme.colors.secondary.opacity(0.1))
                    .frame(height: 250)
                    .overlay(
                        VStack(spacing: theme.spacing.sm) {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                            Text(TextManager.shared.texts.loadingImage)
                                .font(theme.typography.caption)
                                .foregroundColor(theme.colors.secondary)
                        }
                    )
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.bottom, theme.spacing.md)
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Create comment

private extension SuggestionDetailView {
    var addCommentSheet: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            headerCommentSheet
            contentCommentSheet
        }
        .background(theme.colors.background)
        .onAppear {
            isCommentFocused = true
        }
    }

    var headerCommentSheet: some View {
        ZStack {
            HStack {
                Button {
                    showingAddComment = false

                    viewModel.resetCommentForm()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 18, weight: .medium))
                        .foregroundColor(theme.colors.secondary)
                        .padding(8)
                        .background(
                            Circle()
                                .fill(theme.colors.secondary.opacity(0.1))
                        )
                }
                .buttonStyle(.plain)
                Spacer()
                Button {
                    Task {
                        await viewModel.submitComment(for: currentSuggestion.id) {
                            showingAddComment = false
                        }
                    }
                } label: {
                    Image(systemName: "paperplane.fill")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(
                            viewModel.isCommentFormValid &&
                            !viewModel.isSubmittingComment ?
                                .white : theme.colors.secondary
                        )
                        .padding(8)
                        .background(
                            Circle()
                                .fill(
                                    viewModel.isCommentFormValid && !viewModel.isSubmittingComment
                                    ? theme.colors.primary
                                    : theme.colors.secondary.opacity(0.1)
                                )
                        )
                }
                .disabled(!viewModel.isCommentFormValid || viewModel.isSubmittingComment)
                .buttonStyle(.plain)
            }
            HStack(alignment: .center) {
                Spacer()
                Text(TextManager.shared.texts.newComment)
                    .font(theme.typography.headline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
            }
        }
        .padding(theme.spacing.md)
        .background(
            theme.colors.background
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }

    var contentCommentSheet: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: theme.spacing.md) {
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
            .padding(.horizontal, theme.spacing.md)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
    }
}
