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
            .navigationTitle(ConfigurationManager.currentTexts.suggestionTitle)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(ConfigurationManager.currentTexts.close) {
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
                                    title: Text(ConfigurationManager.currentTexts.deleteSuggestionTitle),
                                    message: Text(ConfigurationManager.currentTexts.deleteSuggestionMessage),
                                    primaryButton: .destructive(Text(ConfigurationManager.currentTexts.delete)) {
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
        .alert(ConfigurationManager.currentTexts.error, isPresented: $viewModel.showingError) {
            Button(ConfigurationManager.currentTexts.ok) {}
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
                VStack(alignment: .leading, spacing: theme.spacing.md) {
                    if let nickname = currentSuggestion.nickname {
                        Text("\(ConfigurationManager.currentTexts.suggestedBy) \(nickname)")
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.secondary)
                    } else {
                        Text(ConfigurationManager.currentTexts.suggestedAnonymously)
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.secondary)
                    }
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
        }
    }

    var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text(ConfigurationManager.currentTexts.commentsSection)
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
            if viewModel.isLoadingComments {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text(ConfigurationManager.currentTexts.loadingComments)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.secondary)
                }
                .padding()
            } else if viewModel.comments.isEmpty {
                Text(ConfigurationManager.currentTexts.noComments)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .padding()
            } else {
                LazyVStack(alignment: .leading, spacing: theme.spacing.md) {
                    ForEach(Array(viewModel.comments.enumerated()), id: \.element.id) { _, comment in
                        CommentCard(
                            comment: comment,
                            currentDeviceId: DeviceManager.shared.deviceId,
                            alert: AlertEntity(
                                title: ConfigurationManager.currentTexts.deleteCommentTitle,
                                message: ConfigurationManager.currentTexts.deleteCommentMessage,
                                primaryButtonTitle: ConfigurationManager.currentTexts.deleteCommentPrimary
                            ),
                            onDelete: {
                                Task {
                                    await viewModel.deleteComment(comment)
                                }
                            }
                        )
                    }
                }
            }
        }
    }

    var addCommentSheet: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: theme.spacing.lg) {
                Text(ConfigurationManager.currentTexts.addComment)
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onBackground)
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text(ConfigurationManager.currentTexts.yourComment)
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                    TextField(
                        ConfigurationManager.currentTexts.shareYourThoughts,
                        text: $viewModel.newComment,
                        axis: .vertical
                    )
                    .textFieldStyle(VoticeTextFieldStyle())
                    .lineLimit(3...8)
                    .focused($isCommentFocused)
                }
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text(ConfigurationManager.currentTexts.yourNameOptional)
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                    TextField(ConfigurationManager.currentTexts.enterYourName, text: $viewModel.commentNickname)
                        .textFieldStyle(VoticeTextFieldStyle())
                }
                Spacer()
            }
            .padding(theme.spacing.md)
            .navigationTitle(ConfigurationManager.currentTexts.newComment)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(ConfigurationManager.currentTexts.cancel) {
                        showingAddComment = false

                        viewModel.resetCommentForm()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(ConfigurationManager.currentTexts.post) {
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
    }
}
