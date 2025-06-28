//
//  FetchSuggestionsUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol FetchSuggestionsUseCaseProtocol: Sendable {
    func execute(limit: Int?, offset: Int?, status: String?) async throws -> FetchSuggestionsResponse
}

final class FetchSuggestionsUseCase: FetchSuggestionsUseCaseProtocol {
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

    // MARK: - FetchSuggestionsUseCaseProtocol

    func execute(limit: Int? = nil,
                 offset: Int? = nil,
                 status: String? = nil) async throws -> FetchSuggestionsResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate limit if provided
        if let limit = limit, limit <= 0 {
            throw VoticeError.invalidInput("Limit must be greater than 0")
        }

        // Validate offset if provided
        if let offset = offset, offset < 0 {
            throw VoticeError.invalidInput("Offset must be greater than or equal to 0")
        }

        // Create request
        let request = FetchSuggestionsRequest(
            deviceId: deviceManager.deviceId,
            limit: limit,
            offset: offset,
            status: status,
            platform: deviceManager.platform,
            language: deviceManager.language
        )

        // Execute request
        return try await suggestionRepository.fetchSuggestions(request: request)
    }
}

// MARK: - Sendable Conformance

extension FetchSuggestionsUseCase: @unchecked Sendable {}
