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

    private let commentUseCase: CommentUseCase
    private let suggestionUseCase: SuggestionUseCase

    init(commentUseCase: CommentUseCase = CommentUseCase(),
         suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.commentUseCase = commentUseCase
        self.suggestionUseCase = suggestionUseCase
    }

    // MARK: - Public Methods

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

    func addComment(to suggestionId: String, text: String, nickname: String?) async {
        guard !isSubmittingComment else { return }

        isSubmittingComment = true

        do {
            let response = try await commentUseCase.createComment(suggestionId: suggestionId,
                                                                  text: text,
                                                                  nickname: nickname)

            comments.append(response.comment)
        } catch {
            handleError(error)
        }

        isSubmittingComment = false
    }

    func vote(on suggestionId: String, type: VoteType) async {
        do {
            let response = try await suggestionUseCase.vote(
                suggestionId: suggestionId,
                voteType: type
            )

#warning("Revisar esto del voto en el detalle.")
            /**
             if response.voteStatus.voted {
             currentVote = type
             } else {
             currentVote = nil
             }*/
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
