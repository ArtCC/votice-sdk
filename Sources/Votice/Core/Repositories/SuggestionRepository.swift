//
//  SuggestionRepository.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

final class SuggestionRepository: SuggestionRepositoryProtocol {
    // MARK: - Properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - SuggestionRepositoryProtocol

    func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/suggestions/create",
            method: .POST,
            body: bodyData
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: CreateSuggestionResponse.self
        )
    }

    func fetchSuggestions(request: FetchSuggestionsRequest) async throws -> FetchSuggestionsResponse {
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/suggestions/fetch?appId=\(request.appId)",
            method: .GET,
            body: nil
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: FetchSuggestionsResponse.self
        )
    }

    func fetchVoteStatus(for suggestionId: String) async throws -> VoteStatusEntity {
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/votes/status?suggestionId=\(suggestionId)",
            method: .GET,
            body: nil
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: VoteStatusEntity.self
        )
    }

    func voteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/votes/vote",
            method: .POST,
            body: bodyData
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: VoteSuggestionResponse.self
        )
    }

    func unvoteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/votes/unvote",
            method: .POST,
            body: bodyData
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: VoteSuggestionResponse.self
        )
    }
}

// MARK: - Sendable Conformance

extension SuggestionRepository: @unchecked Sendable {}
