//
//  FetchCommentsUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol FetchCommentsUseCaseProtocol: Sendable {
    func execute(suggestionId: String, limit: Int?, offset: Int?) async throws -> FetchCommentsResponse
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

    func execute(suggestionId: String, limit: Int? = nil, offset: Int? = nil) async throws -> FetchCommentsResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate input
        guard !suggestionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        // Validate limit if provided
        if let limit = limit, limit <= 0 {
            throw VoticeError.invalidInput("Limit must be greater than 0")
        }

        // Validate offset if provided
        if let offset = offset, offset < 0 {
            throw VoticeError.invalidInput("Offset must be greater than or equal to 0")
        }

        // Create request
        let request = FetchCommentsRequest(
            suggestionId: suggestionId.trimmingCharacters(in: .whitespacesAndNewlines),
            deviceId: deviceManager.deviceId,
            limit: limit,
            offset: offset,
            platform: deviceManager.platform,
            language: deviceManager.language
        )

        // Execute request
        return try await commentRepository.fetchComments(request: request)
    }
}

// MARK: - Sendable Conformance

extension FetchCommentsUseCase: @unchecked Sendable {}
