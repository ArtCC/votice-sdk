//
//  CreateSuggestionUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol CreateSuggestionUseCaseProtocol: Sendable {
    func execute(title: String, description: String, nickname: String?) async throws -> CreateSuggestionResponse
}

final class CreateSuggestionUseCase: CreateSuggestionUseCaseProtocol {
    // MARK: - Properties

    private let suggestionRepository: SuggestionRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Initialization

    init(
        suggestionRepository: SuggestionRepositoryProtocol = SuggestionRepository(),
        configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
        deviceManager: DeviceManagerProtocol = DeviceManager.shared
    ) {
        self.suggestionRepository = suggestionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - CreateSuggestionUseCaseProtocol

    func execute(title: String, description: String, nickname: String?) async throws -> CreateSuggestionResponse {
        // Validate configuration
        try configurationManager.validateConfiguration()

        // Validate input
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Title cannot be empty")
        }

        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Description cannot be empty")
        }

        // Create request
        let request = CreateSuggestionRequest(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            deviceId: deviceManager.deviceId,
            nickname: nickname?.trimmingCharacters(in: .whitespacesAndNewlines),
            platform: deviceManager.platform,
            language: deviceManager.language
        )

        // Execute request
        return try await suggestionRepository.createSuggestion(request: request)
    }
}

// MARK: - Sendable Conformance

extension CreateSuggestionUseCase: @unchecked Sendable {}
