//
//  SuggestionDetailView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Suggestion Detail View

struct SuggestionDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.voticeTheme) private var theme

    let suggestion: SuggestionEntity
    let onSuggestionUpdated: (SuggestionEntity) -> Void

    @StateObject private var viewModel = SuggestionDetailViewModel()
    @State private var showingAddComment = false
    @State private var newComment = ""
    @State private var commentNickname = ""

    @FocusState private var isCommentFocused: Bool

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
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showingAddComment = true
                    } label: {
                        Image(systemName: "bubble.left")
                            .foregroundColor(theme.colors.primary)
                    }
                }
#else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showingAddComment = true
                    } label: {
                        Image(systemName: "bubble.left")
                            .foregroundColor(theme.colors.primary)
                    }
                }
#endif
            }
        }
        .task {
            await viewModel.loadComments(for: suggestion.id)
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

    private var suggestionHeader: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            // Status Badge
            HStack {
                StatusBadge(status: suggestion.status ?? .pending)

                Spacer()

                SourceIndicator(source: suggestion.source ?? .sdk)
            }

            // Title/Text
            Text(suggestion.displayText)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.leading)
        }
    }

    private var suggestionContent: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            // Description (if different from title)
            if let description = suggestion.description,
               description != suggestion.title {
                Text(description)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.onBackground)
            }

            // Metadata
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
}

private extension SuggestionDetailView {
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
                        CommentCard(comment: comment)
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
#endif
            .toolbar {
#if os(iOS)
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
#else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        showingAddComment = false
                        resetCommentForm()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Post") {
                        Task {
                            await postComment()
                        }
                    }
                    .disabled(
                        newComment.trimmingCharacters(
                            in: .whitespacesAndNewlines).isEmpty ||
                        viewModel.isSubmittingComment
                    )
                }
#endif
            }
        }
        .onAppear {
            isCommentFocused = true
        }
    }

    func postComment() async {
        let trimmedNickname = commentNickname.trimmingCharacters(in: .whitespacesAndNewlines)

        await viewModel.addComment(
            to: suggestion.id,
            content: newComment,
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

// MARK: - Comment Card

private struct CommentCard: View {
    @Environment(\.voticeTheme) private var theme

    let comment: CommentEntity

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Text(comment.displayName)
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.onSurface)

                Spacer()

                if let createdAt = comment.createdAt, let date = Date.formatFromISOString(createdAt) {
                    Text(date)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
            }

            Text(comment.text)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.onSurface)
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .cornerRadius(theme.cornerRadius.md)
    }
}

// MARK: - Status Badge

private struct StatusBadge: View {
    @Environment(\.voticeTheme) private var theme

    let status: SuggestionStatusEntity

    private var statusColor: Color {
        switch status {
        case .pending: return theme.colors.pending
        case .accepted: return theme.colors.accepted
        case .inProgress: return theme.colors.inProgress
        case .completed: return theme.colors.completed
        case .rejected: return theme.colors.rejected
        }
    }

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
            .background(statusColor)
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
