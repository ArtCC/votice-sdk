//
//  FetchSuggestionsUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol FetchSuggestionsUseCaseProtocol: Sendable {
    func execute() async throws -> FetchSuggestionsResponse
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

    func execute() async throws -> FetchSuggestionsResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Create request
        let request = FetchSuggestionsRequest(appId: configurationManager.appId)

        // Execute request
        return try await suggestionRepository.fetchSuggestions(request: request)
    }
}

// MARK: - Sendable Conformance

extension FetchSuggestionsUseCase: @unchecked Sendable {}
