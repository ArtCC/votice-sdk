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

    private let fetchCommentsUseCase: FetchCommentsUseCase
    private let createCommentUseCase: CreateCommentUseCase
    private let voteSuggestionUseCase: VoteSuggestionUseCase

    init(
        fetchCommentsUseCase: FetchCommentsUseCase = FetchCommentsUseCase(),
        createCommentUseCase: CreateCommentUseCase = CreateCommentUseCase(),
        voteSuggestionUseCase: VoteSuggestionUseCase = VoteSuggestionUseCase()
    ) {
        self.fetchCommentsUseCase = fetchCommentsUseCase
        self.createCommentUseCase = createCommentUseCase
        self.voteSuggestionUseCase = voteSuggestionUseCase
    }

    // MARK: - Public Methods

    func loadComments(for suggestionId: String) async {
        guard !isLoadingComments else { return }

        isLoadingComments = true

        do {
            let response = try await fetchCommentsUseCase.execute(
                suggestionId: suggestionId,
                limit: nil,
                offset: nil
            )

            comments = response.comments.sorted { $0.createdAt! < $1.createdAt! }
        } catch {
            handleError(error)
        }

        isLoadingComments = false
    }

    func addComment(to suggestionId: String, content: String, nickname: String?) async {
        guard !isSubmittingComment else { return }

        isSubmittingComment = true

        do {
            let response = try await createCommentUseCase.execute(
                suggestionId: suggestionId,
                content: content,
                nickname: nickname
            )

            // Create a temporary CommentEntity for the UI
            let comment = CommentEntity(
                id: response.id,
                suggestionId: suggestionId,
                appId: ConfigurationManager.shared.appId,
                text: content,
                nickname: nickname,
                createdBy: DeviceManager.shared.deviceId,
                deviceId: DeviceManager.shared.deviceId,
                createdAt: Date().ISO8601Format()
            )

            comments.append(comment)
        } catch {
            handleError(error)
        }

        isSubmittingComment = false
    }

    func vote(on suggestionId: String, type: VoteType) async {
        do {
            let response = try await voteSuggestionUseCase.execute(
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
