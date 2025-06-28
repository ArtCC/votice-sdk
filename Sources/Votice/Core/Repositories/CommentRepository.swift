//
//  CommentRepository.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

final class CommentRepository: CommentRepositoryProtocol {
    // MARK: - Properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - CommentRepositoryProtocol

    func createComment(request: CreateCommentRequest) async throws -> CreateCommentResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/comments/create",
            method: .POST,
            body: bodyData
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: CreateCommentResponse.self
        )
    }

    func fetchComments(request: FetchCommentsRequest) async throws -> FetchCommentsResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(
            path: "/v1/sdk/comments/fetch",
            method: .GET,
            body: bodyData
        )
        return try await networkManager.request(
            endpoint: endpoint,
            responseType: FetchCommentsResponse.self
        )
    }
}

// MARK: - Sendable Conformance

extension CommentRepository: @unchecked Sendable {}
