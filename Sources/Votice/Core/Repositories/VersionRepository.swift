//
//  VersionRepository.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol VersionRepositoryProtocol: Sendable {
    func report(request: VersionRequest) async throws -> VersionResponse
}

final class VersionRepository: VersionRepositoryProtocol {
    // MARK: - Properties

    private let networkManager: NetworkManagerProtocol

    // MARK: - Init

    init(networkManager: NetworkManagerProtocol = NetworkManager.shared) {
        self.networkManager = networkManager
    }

    // MARK: - VersionRepositoryProtocol

    func report(request: VersionRequest) async throws -> VersionResponse {
        let bodyData = try JSONEncoder().encode(request)
        let endpoint = NetworkEndpoint(path: "/v1/sdk/version/report", method: .POST, body: bodyData)

        return try await networkManager.request(endpoint: endpoint, responseType: VersionResponse.self)
    }
}
