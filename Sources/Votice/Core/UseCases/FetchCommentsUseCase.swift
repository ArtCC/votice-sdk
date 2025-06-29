//
//  FetchCommentsUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol FetchCommentsUseCaseProtocol: Sendable {
    func execute(suggestionId: String) async throws -> FetchCommentsResponse
}

final class FetchCommentsUseCase: FetchCommentsUseCaseProtocol {
    // MARK: - Properties

    private let commentRepository: CommentRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(
        commentRepository: CommentRepositoryProtocol = CommentRepository(),
        configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
        deviceManager: DeviceManagerProtocol = DeviceManager.shared
    ) {
        self.commentRepository = commentRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - FetchCommentsUseCaseProtocol

    func execute(suggestionId: String) async throws -> FetchCommentsResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate input
        guard !suggestionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        // Create request
        let request = FetchCommentsRequest(suggestionId: suggestionId.trimmingCharacters(in: .whitespacesAndNewlines))

        // Execute request
        return try await commentRepository.fetchComments(request: request)
    }
}

// MARK: - Sendable Conformance

extension FetchCommentsUseCase: @unchecked Sendable {}
