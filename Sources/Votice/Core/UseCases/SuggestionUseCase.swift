//
//  SuggestionUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol SuggestionUseCaseProtocol: Sendable {
    func fetchSuggestions() async throws -> SuggestionsResponse
    func createSuggestion(title: String,
                          description: String?,
                          nickname: String?) async throws -> CreateSuggestionResponse
    func deleteSuggestion(suggestionId: String) async throws -> DeleteSuggestionResponse
    func fetchVoteStatus(suggestionId: String) async throws -> VoteStatusEntity
    func vote(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse
}

final class SuggestionUseCase: SuggestionUseCaseProtocol {
    // MARK: - Properties

    private let suggestionRepository: SuggestionRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(suggestionRepository: SuggestionRepositoryProtocol = SuggestionRepository(),
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
         deviceManager: DeviceManagerProtocol = DeviceManager.shared) {
        self.suggestionRepository = suggestionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - SuggestionUseCaseProtocol

    func fetchSuggestions() async throws -> SuggestionsResponse {
        try configurationManager.validateConfiguration()

        let request = FetchSuggestionsRequest(appId: configurationManager.appId)

        return try await suggestionRepository.fetchSuggestions(request: request)
    }

    func createSuggestion(title: String,
                          description: String?,
                          nickname: String?) async throws -> CreateSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !title.isEmpty else {
            throw VoticeError.invalidInput("Title cannot be empty")
        }

        let request = CreateSuggestionRequest(title: title,
                                              description: description,
                                              deviceId: deviceManager.deviceId,
                                              nickname: nickname,
                                              platform: deviceManager.platform,
                                              language: deviceManager.language)

        return try await suggestionRepository.createSuggestion(request: request)
    }

    func deleteSuggestion(suggestionId: String) async throws -> DeleteSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = DeleteSuggestionRequest(suggestionId: suggestionId, deviceId: deviceManager.deviceId)

        return try await suggestionRepository.deleteSuggestion(request: request)
    }

    func fetchVoteStatus(suggestionId: String) async throws -> VoteStatusEntity {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = VoteStatusRequest(suggestionId: suggestionId, deviceId: deviceManager.deviceId)

        return try await suggestionRepository.fetchVoteStatus(request: request)
    }

    func vote(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = VoteSuggestionRequest(suggestionId: suggestionId,
                                            deviceId: deviceManager.deviceId,
                                            voteType: voteType)

        switch voteType {
        case .upvote:
            return try await suggestionRepository.voteSuggestion(request: request)
        case .downvote:
            return try await suggestionRepository.unvoteSuggestion(request: request)
        }
    }
}
