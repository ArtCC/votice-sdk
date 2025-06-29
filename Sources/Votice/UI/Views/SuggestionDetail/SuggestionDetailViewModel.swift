//
//  SuggestionDetailViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Suggestion Detail View Model

@MainActor
final class SuggestionDetailViewModel: ObservableObject {
    @Published var comments: [CommentEntity] = []
    @Published var isLoadingComments = false
    @Published var isSubmittingComment = false
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var currentVote: VoteType?
    @Published var suggestionEntity: SuggestionEntity?
    @Published var reload = false

    private let commentUseCase: CommentUseCase
    private let suggestionUseCase: SuggestionUseCase

    init(commentUseCase: CommentUseCase = CommentUseCase(),
         suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.commentUseCase = commentUseCase
        self.suggestionUseCase = suggestionUseCase
    }

    // MARK: - Public Methods

    func loadInitialData(for suggestion: SuggestionEntity) async {
        self.suggestionEntity = suggestion

        await loadComments(for: suggestion.id)
        await loadVoteStatus(for: suggestion.id)
    }

    func loadComments(for suggestionId: String) async {
        guard !isLoadingComments else { return }

        isLoadingComments = true

        do {
            let response = try await commentUseCase.fetchComments(suggestionId: suggestionId)

            comments = response.comments.sorted { $0.createdAt! < $1.createdAt! }
        } catch {
            handleError(error)
        }

        isLoadingComments = false
    }

    func loadVoteStatus(for suggestionId: String) async {
        do {
            let voteStatus = try await suggestionUseCase.fetchVoteStatus(suggestionId: suggestionId)

            if voteStatus.hasVoted {
                // Since VoteStatusEntity doesn't include the vote type,
                // we'll assume it's an upvote for now
                currentVote = .upvote
            } else {
                currentVote = nil
            }
        } catch {
            // Log error but don't fail - vote status is not critical
            LogManager.shared.devLog(.error, "Failed to load vote status: \(error)")
        }
    }

    func addComment(to suggestionId: String, text: String, nickname: String?) async {
        guard !isSubmittingComment else { return }

        isSubmittingComment = true

        do {
            let response = try await commentUseCase.createComment(suggestionId: suggestionId,
                                                                  text: text,
                                                                  nickname: nickname)

            comments.append(response.comment)

            // Update suggestionEntity with new comment count
            if let current = suggestionEntity {
                let newCommentCount = (current.commentCount ?? 0) + 1
                suggestionEntity = SuggestionEntity(
                    id: current.id,
                    appId: current.appId,
                    title: current.title,
                    text: current.text,
                    description: current.description,
                    nickname: current.nickname,
                    createdAt: current.createdAt,
                    updatedAt: current.updatedAt,
                    platform: current.platform,
                    createdBy: current.createdBy,
                    status: current.status,
                    source: current.source,
                    commentCount: newCommentCount,
                    voteCount: current.voteCount
                )
            }

            reload = true
        } catch {
            handleError(error)
        }

        isSubmittingComment = false
    }

    func deleteComment(_ comment: CommentEntity) async {
        do {
            try await commentUseCase.deleteComment(commentId: comment.id)
            comments.removeAll { $0.id == comment.id }
            // Actualiza el contador de comentarios en la sugerencia
            if let current = suggestionEntity {
                let newCount = max((current.commentCount ?? 1) - 1, 0)

                suggestionEntity = SuggestionEntity(
                    id: current.id,
                    appId: current.appId,
                    title: current.title,
                    text: current.text,
                    description: current.description,
                    nickname: current.nickname,
                    createdAt: current.createdAt,
                    updatedAt: current.updatedAt,
                    platform: current.platform,
                    createdBy: current.createdBy,
                    status: current.status,
                    source: current.source,
                    commentCount: newCount,
                    voteCount: current.voteCount
                )

                reload = true
            }
            reload = true
        } catch {
            handleError(error)
        }
    }

    func vote(on suggestionId: String, type: VoteType) async {
        do {
            let hasCurrentVote = currentVote != nil
            let response: VoteSuggestionResponse

            if hasCurrentVote {
                // User already voted, so this is an unvote action
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .downvote)
            } else {
                // User hasn't voted, so this is a vote action
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .upvote)
            }

            // Update local vote state based on response
            if let vote = response.vote {
                currentVote = type
            } else {
                currentVote = nil
            }

            // Update suggestionEntity with new vote count from backend
            if let updatedSuggestion = response.suggestion,
               let current = suggestionEntity {
                suggestionEntity = SuggestionEntity(
                    id: current.id,
                    appId: current.appId,
                    title: current.title,
                    text: current.text,
                    description: current.description,
                    nickname: current.nickname,
                    createdAt: current.createdAt,
                    updatedAt: updatedSuggestion.updatedAt,
                    platform: current.platform,
                    createdBy: current.createdBy,
                    status: current.status,
                    source: current.source,
                    commentCount: current.commentCount,
                    voteCount: updatedSuggestion.voteCount
                )
            }

            reload = true
        } catch {
            handleError(error)
        }
    }

    // MARK: - Private Methods

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
        LogManager.shared.devLog(.error, "SuggestionDetailViewModel error: \(error)")
    }
}
