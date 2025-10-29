//
//  SuggestionUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public protocol SuggestionUseCaseProtocol: Sendable {
    func fetchFilterApplied() throws -> SuggestionStatusEntity?
    func setFilterApplied(_ status: SuggestionStatusEntity?) throws
    func clearFilterApplied() throws
    func fetchSuggestions(
        status: SuggestionStatusEntity?,
        excludeCompleted: Bool,
        pagination: PaginationRequest
    ) async throws -> SuggestionsResponse
    func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse
    func deleteSuggestion(suggestionId: String) async throws -> DeleteSuggestionResponse
    func fetchVoteStatus(suggestionId: String) async throws -> VoteStatusEntity
    func vote(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse
    func uploadImage(request: UploadImageRequest) async throws -> UploadImageResponse
}

public final class SuggestionUseCase: SuggestionUseCaseProtocol {
    // MARK: - Properties

    private let storageManager: StorageManagerProtocol
    private let suggestionRepository: SuggestionRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(storageManager: StorageManagerProtocol = StorageManager(),
         suggestionRepository: SuggestionRepositoryProtocol = SuggestionRepository(),
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
         deviceManager: DeviceManagerProtocol = DeviceManager.shared) {
        self.storageManager = storageManager
        self.suggestionRepository = suggestionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - SuggestionUseCaseProtocol

    public func fetchFilterApplied() throws -> SuggestionStatusEntity? {
        try storageManager.load(forKey: StorageKey.filterApplied.rawValue, as: SuggestionStatusEntity.self)
    }

    public func setFilterApplied(_ status: SuggestionStatusEntity?) throws {
        try storageManager.save(status, forKey: StorageKey.filterApplied.rawValue)
    }

    public func clearFilterApplied() throws {
        try storageManager.delete(forKey: StorageKey.filterApplied.rawValue)
    }

    public func fetchSuggestions(
        status: SuggestionStatusEntity?,
        excludeCompleted: Bool,
        pagination: PaginationRequest
    ) async throws -> SuggestionsResponse {
        try configurationManager.validateConfiguration()

        let request = FetchSuggestionsRequest(
            appId: configurationManager.appId,
            status: status,
            excludeCompleted: excludeCompleted,
            pagination: pagination
        )

        return try await suggestionRepository.fetchSuggestions(request: request)
    }

    public func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !request.title.isEmpty else {
            throw VoticeError.invalidInput("Title cannot be empty")
        }

        let entity = CreateSuggestionRequest(
            title: request.title,
            description: request.description,
            deviceId: deviceManager.deviceId,
            nickname: request.nickname,
            platform: deviceManager.platform,
            language: deviceManager.language,
            userIsPremium: request.userIsPremium,
            issue: request.issue,
            urlImage: request.urlImage
        )

        return try await suggestionRepository.createSuggestion(request: entity)
    }

    public func deleteSuggestion(suggestionId: String) async throws -> DeleteSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = DeleteSuggestionRequest(suggestionId: suggestionId, deviceId: deviceManager.deviceId)

        return try await suggestionRepository.deleteSuggestion(request: request)
    }

    public func fetchVoteStatus(suggestionId: String) async throws -> VoteStatusEntity {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = VoteStatusRequest(suggestionId: suggestionId, deviceId: deviceManager.deviceId)

        return try await suggestionRepository.fetchVoteStatus(request: request)
    }

    public func vote(suggestionId: String, voteType: VoteType) async throws -> VoteSuggestionResponse {
        try configurationManager.validateConfiguration()

        guard !suggestionId.isEmpty else {
            throw VoticeError.invalidInput("Suggestion ID cannot be empty")
        }

        let request = VoteSuggestionRequest(
            suggestionId: suggestionId,
            deviceId: deviceManager.deviceId,
            voteType: voteType
        )

        switch voteType {
        case .upvote:
            return try await suggestionRepository.voteSuggestion(request: request)
        case .downvote:
            return try await suggestionRepository.unvoteSuggestion(request: request)
        }
    }

    public func uploadImage(request: UploadImageRequest) async throws -> UploadImageResponse {
        try configurationManager.validateConfiguration()

        guard !request.fileName.isEmpty else {
            throw VoticeError.invalidInput("File name cannot be empty")
        }

        guard !request.imageData.isEmpty else {
            throw VoticeError.invalidInput("Image data cannot be empty")
        }

        return try await suggestionRepository.uploadImage(request: request)
    }
}
