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
    @State private var showDeleteAlert = false

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
                theme.colors.background.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        suggestionHeader
                        suggestionContent
                        votingSection
                        Divider()
                            .background(theme.colors.secondary.opacity(0.3))
                        commentsSection
                        Spacer(minLength: theme.spacing.xl)
                    }
                    .padding(theme.spacing.md)
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
                    HStack {
                        Button {
                            showingAddComment = true
                        } label: {
                            Image(systemName: "bubble.left")
                                .foregroundColor(theme.colors.primary)
                        }
                        if currentSuggestion.deviceId == DeviceManager.shared.deviceId {
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .alert(isPresented: $showDeleteAlert) {
                                Alert(
                                    title: Text(TextManager.shared.texts.deleteSuggestionTitle),
                                    message: Text(TextManager.shared.texts.deleteSuggestionMessage),
                                    primaryButton: .destructive(Text(TextManager.shared.texts.delete)) {
                                        Task {
                                            await viewModel.deleteSuggestion(currentSuggestion)

                                            onReload()

                                            dismiss()
                                        }
                                    },
                                    secondaryButton: .cancel()
                                )
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
        .alert(TextManager.shared.texts.error, isPresented: $viewModel.showingError) {
            Button(TextManager.shared.texts.ok) {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// MARK: - Private

private extension SuggestionDetailView {
    // MARK: - Properties

    var suggestionHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                StatusBadge(status: currentSuggestion.status ?? .pending)
                Spacer()
                SourceIndicator(source: currentSuggestion.source ?? .sdk)
            }
            Text(currentSuggestion.displayText)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.leading)
        }
    }

    var suggestionContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            if let description = currentSuggestion.description,
               description != currentSuggestion.title {
                Text(description)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.onBackground)
            }
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                if let nickname = currentSuggestion.nickname {
                    Text("\(TextManager.shared.texts.suggestedBy) \(nickname)")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                } else {
                    Text(TextManager.shared.texts.suggestedAnonymously)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                if let createdAt = currentSuggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
                    Text(date)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
            }
        }
    }

    var votingSection: some View {
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
                Text("\(currentSuggestion.voteCount) \(TextManager.shared.texts.votes)")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
                Text("\(viewModel.comments.count) \(TextManager.shared.texts.comments)")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(TextManager.shared.texts.commentsSection)
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
            if viewModel.isLoadingComments {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text(TextManager.shared.texts.loadingComments)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.secondary)
                }
                .padding()
            } else if viewModel.comments.isEmpty {
                Text(TextManager.shared.texts.noComments)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .padding()
            } else {
                LazyVStack(alignment: .leading, spacing: theme.spacing.md) {
                    ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { index, comment in
                        CommentCard(
                            comment: comment,
                            currentDeviceId: DeviceManager.shared.deviceId,
                            alert: AlertEntity(
                                title: TextManager.shared.texts.deleteCommentTitle,
                                message: TextManager.shared.texts.deleteCommentMessage,
                                primaryButtonTitle: TextManager.shared.texts.deleteCommentPrimary
                            ),
                            onDelete: {
                                Task {
                                    await viewModel.deleteComment(comment)
                                }
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
                            Spacer()
                            ProgressView()
                                .scaleEffect(0.8)
                                .padding()
                            Spacer()
                        }
                    }
                }
            }
        }
    }

    var addCommentSheet: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text(TextManager.shared.texts.addComment)
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onBackground)
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
            .padding(theme.spacing.md)
            .navigationTitle(TextManager.shared.texts.newComment)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(TextManager.shared.texts.cancel) {
                        showingAddComment = false

                        viewModel.resetCommentForm()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(TextManager.shared.texts.post) {
                        Task {
                            await viewModel.submitComment(for: currentSuggestion.id) {
                                showingAddComment = false
                            }
                        }
                    }
                    .disabled(!viewModel.isCommentFormValid || viewModel.isSubmittingComment)
                }
            }
#endif
        }
        .onAppear {
            isCommentFocused = true
        }
    }
}
