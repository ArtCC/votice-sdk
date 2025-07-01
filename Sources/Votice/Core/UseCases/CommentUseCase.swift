//
//  CommentUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol CommentUseCaseProtocol: Sendable {
    func fetchComments(suggestionId: String, pagination: PaginationRequest) async throws -> CommentsResponse
    func createComment(suggestionId: String, text: String, nickname: String?) async throws -> CreateCommentResponse
    func deleteComment(commentId: String) async throws
}

final class CommentUseCase: CommentUseCaseProtocol {
    // MARK: - Properties

    private let commentRepository: CommentRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(commentRepository: CommentRepositoryProtocol = CommentRepository(),
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
         deviceManager: DeviceManagerProtocol = DeviceManager.shared) {
        self.commentRepository = commentRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - CommentUseCaseProtocol

    func fetchComments(suggestionId: String, pagination: PaginationRequest) async throws -> CommentsResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = FetchCommentsRequest(suggestionId: suggestionId, pagination: pagination)

        return try await commentRepository.fetchComments(request: request)
    }

    func createComment(suggestionId: String, text: String, nickname: String?) async throws -> CreateCommentResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        guard !text.isEmpty else {
            throw VoticeError.invalidInput("Comment content cannot be empty")
        }

        let request = CreateCommentRequest(suggestionId: suggestionId,
                                           text: text,
                                           deviceId: deviceManager.deviceId,
                                           nickname: nickname)

        return try await commentRepository.createComment(request: request)
    }

    func deleteComment(commentId: String) async throws {
        try configurationManager.validateConfiguration()

        guard !commentId.isEmpty else {
            throw VoticeError.invalidInput("Comment ID cannot be empty")
        }

        let request = DeleteCommentRequest(commentId: commentId, deviceId: deviceManager.deviceId)

        try await commentRepository.deleteComment(request: request)
    }
}
