//
//  CreateCommentUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol CreateCommentUseCaseProtocol: Sendable {
    func execute(suggestionId: String, content: String, nickname: String?) async throws -> CreateCommentResponse
}

final class CreateCommentUseCase: CreateCommentUseCaseProtocol {
    // MARK: - Properties

    private let commentRepository: CommentRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Initialization

    init(
        commentRepository: CommentRepositoryProtocol = CommentRepository(),
        configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
        deviceManager: DeviceManagerProtocol = DeviceManager.shared
    ) {
        self.commentRepository = commentRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - CreateCommentUseCaseProtocol

    func execute(suggestionId: String, content: String, nickname: String?) async throws -> CreateCommentResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate input
        guard !suggestionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Comment content cannot be empty")
        }

        // Create request
        let request = CreateCommentRequest(
            suggestionId: suggestionId.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            deviceId: deviceManager.deviceId,
            nickname: nickname?.trimmingCharacters(in: .whitespacesAndNewlines),
            platform: deviceManager.platform,
            language: deviceManager.language
        )

        // Execute request
        return try await commentRepository.createComment(request: request)
    }
}

// MARK: - Sendable Conformance

extension CreateCommentUseCase: @unchecked Sendable {}
