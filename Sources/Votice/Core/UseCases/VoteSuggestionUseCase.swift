//
//  VoteSuggestionUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol VoteSuggestionUseCaseProtocol: Sendable {
    func execute(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse
}

final class VoteSuggestionUseCase: VoteSuggestionUseCaseProtocol {
    // MARK: - Properties

    private let suggestionRepository: SuggestionRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(
        suggestionRepository: SuggestionRepositoryProtocol = SuggestionRepository(),
        configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
        deviceManager: DeviceManagerProtocol = DeviceManager.shared
    ) {
        self.suggestionRepository = suggestionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - VoteSuggestionUseCaseProtocol

    func execute(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate input
        guard !suggestionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        // Create request
        let request = VoteSuggestionRequest(suggestionId: suggestionId.trimmingCharacters(in: .whitespacesAndNewlines),
                                            deviceId: deviceManager.deviceId,
                                            voteType: voteType)

        // Execute request
        switch voteType {
        case .upvote:
            return try await suggestionRepository.voteSuggestion(request: request)
        case .downvote:
            return try await suggestionRepository.unvoteSuggestion(request: request)
        }
    }
}

// MARK: - Sendable Conformance

extension VoteSuggestionUseCase: @unchecked Sendable {}
