//
//  SuggestionRepository.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol SuggestionRepositoryProtocol: Sendable {
    func fetchSuggestions(request: FetchSuggestionsRequest) async throws -> SuggestionsResponse
    func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse
    func deleteSuggestion(request: DeleteSuggestionRequest) async throws -> DeleteSuggestionResponse
    func fetchVoteStatus(request: VoteStatusRequest) async throws -> VoteStatusEntity
    func voteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse
    func unvoteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse
    func uploadImage(request: UploadImageRequest) async throws -> UploadImageResponse
}

final class SuggestionRepository: SuggestionRepositoryProtocol {
    // MARK: - Properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - SuggestionRepositoryProtocol

    func fetchSuggestions(request: FetchSuggestionsRequest) async throws -> SuggestionsResponse {
        var path = "/v1/sdk/suggestions/fetch?appId=\(request.appId)"

        if let startAfter = request.pagination.startAfter {
            path += "&startAfter={\"voteCount\":\(startAfter.voteCount ?? 0),\"createdAt\":\"\(startAfter.createdAt)\"}"
        }

        if let pageLimit = request.pagination.pageLimit {
            path += "&pageLimit=\(pageLimit)"
        }

        let endpoint = NetworkEndpoint(path: path, method: .GET, body: nil)

        return try await networkManager.request(endpoint: endpoint, responseType: SuggestionsResponse.self)
    }

    func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/suggestions/create", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: CreateSuggestionResponse.self)
    }

    func deleteSuggestion(request: DeleteSuggestionRequest) async throws -> DeleteSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/suggestions/delete", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: DeleteSuggestionResponse.self)
    }

    func fetchVoteStatus(request: VoteStatusRequest) async throws -> VoteStatusEntity {
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/votes/status?suggestionId=\(request.suggestionId)&deviceId=\(request.deviceId)",
            method: .GET,
            body: nil
        )

        return try await networkManager.request(endpoint: endpoint, responseType: VoteStatusEntity.self)
    }

    func voteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/votes/vote", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: VoteSuggestionResponse.self)
    }

    func unvoteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/votes/unvote", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: VoteSuggestionResponse.self)
    }

    func uploadImage(request: UploadImageRequest) async throws -> UploadImageResponse {
        let base64String = request.imageData.base64EncodedString()
        let requestBody: [String: Any] = [
            "imageData": "data:image/jpeg;base64,\(base64String)",
            "fileName": request.fileName,
            "mimeType": "image/jpeg"
        ]
        let bodyData = try JSONSerialization.data(withJSONObject: requestBody)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/suggestions/upload-image", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: UploadImageResponse.self)
    }
}
