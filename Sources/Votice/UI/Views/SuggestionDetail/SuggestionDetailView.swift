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
    @State private var newComment = ""
    @State private var commentNickname = ""
    @State private var showDeleteAlert = false

    @FocusState private var isCommentFocused: Bool

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
            .navigationTitle("Suggestion")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
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
                        if suggestion.deviceId == DeviceManager.shared.deviceId {
                            Button(role: .destructive) {
                                showDeleteAlert = true
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                            }
                            .alert(isPresented: $showDeleteAlert) {
                                Alert(
                                    title: Text("Delete Suggestion"),
                                    message: Text("Are you sure you want to delete this suggestion?"),
                                    primaryButton: .destructive(Text("Delete")) {
                                        Task {
                                            await viewModel.deleteSuggestion(suggestion)

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
            await viewModel.loadInitialData(for: suggestion)
        }
        .onDisappear {
            if viewModel.reload, let suggestionEntity = viewModel.suggestionEntity {
                onSuggestionUpdated(suggestionEntity)
            }
        }
        .sheet(isPresented: $showingAddComment) {
            addCommentSheet
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") {}
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
                StatusBadge(status: suggestion.status ?? .pending)
                Spacer()
                SourceIndicator(source: suggestion.source ?? .sdk)
            }
            Text(suggestion.displayText)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.leading)
        }
    }

    var suggestionContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            if let description = suggestion.description,
               description != suggestion.title {
                Text(description)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.onBackground)
            }
            VStack(alignment: .leading, spacing: theme.spacing.xs) {
                if let nickname = suggestion.nickname {
                    Text("Suggested by \(nickname)")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                } else {
                    Text("Suggested anonymously")
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                if let createdAt = suggestion.createdAt, let date = Date.formatFromISOString(createdAt) {
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
                upvotes: max(0, suggestion.voteCount ?? 0),
                downvotes: 0,
                currentVote: viewModel.currentVote,
                onVote: { voteType in
                    Task {
                        await viewModel.vote(on: suggestion.id, type: voteType)
                    }
                }
            )
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text("\(suggestion.voteCount) votes")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
                Text("\(viewModel.comments.count) comments")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    var commentsSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            Text("Comments")
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
            if viewModel.isLoadingComments {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading comments...")
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.secondary)
                }
                .padding()
            } else if viewModel.comments.isEmpty {
                Text("No comments yet. Be the first to comment!")
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .padding()
            } else {
                LazyVStack(alignment: .leading, spacing: theme.spacing.md) {
                    ForEach(viewModel.comments) { comment in
                        CommentCard(
                            comment: comment,
                            currentDeviceId: DeviceManager.shared.deviceId,
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
                Text("Add a comment")
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onBackground)
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Your Comment")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                    TextField("Share your thoughts...", text: $newComment, axis: .vertical)
                        .textFieldStyle(VoticeTextFieldStyle())
                        .lineLimit(3...8)
                        .focused($isCommentFocused)
                }
                VStack(alignment: .leading, spacing: theme.spacing.sm) {
                    Text("Your Name (Optional)")
                        .font(theme.typography.headline)
                        .foregroundColor(theme.colors.onBackground)
                    TextField("Enter your name", text: $commentNickname)
                        .textFieldStyle(VoticeTextFieldStyle())
                }
                Spacer()
            }
            .padding(theme.spacing.md)
            .navigationTitle("New Comment")
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        showingAddComment = false
                        resetCommentForm()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Post") {
                        Task {
                            await postComment()
                        }
                    }
                    .disabled(
                        newComment.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                        viewModel.isSubmittingComment
                    )
                }
            }
#endif
        }
        .onAppear {
            isCommentFocused = true
        }
    }
}

private extension SuggestionDetailView {
    // MARK: - Functions

    func postComment() async {
        let trimmedNickname = commentNickname.trimmingCharacters(in: .whitespacesAndNewlines)

        await viewModel.addComment(
            to: suggestion.id,
            text: newComment,
            nickname: trimmedNickname.isEmpty ? nil : trimmedNickname
        )

        if !viewModel.showingError {
            showingAddComment = false

            resetCommentForm()
        }
    }

    func resetCommentForm() {
        newComment = ""
        commentNickname = ""
    }
}
