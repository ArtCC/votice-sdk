//
//  VersionUseCase.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol VersionUseCaseProtocol: Sendable {
    func report() async throws -> VersionResponse
}

final class VersionUseCase: VersionUseCaseProtocol {
    // MARK: - Properties

    private let versionRepository: VersionRepositoryProtocol
    private let configurationManager: ConfigurationManagerProtocol
    private let deviceManager: DeviceManagerProtocol

    // MARK: - Init

    init(versionRepository: VersionRepositoryProtocol = VersionRepository(),
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
         deviceManager: DeviceManagerProtocol = DeviceManager.shared) {
        self.versionRepository = versionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
    }

    // MARK: - VersionUseCaseProtocol

    func report() async throws -> VersionResponse {
        try configurationManager.validateConfiguration()

        let request: VersionRequest = .init(version: configurationManager.version,
                                            buildNumber: configurationManager.buildNumber,
                                            platform: deviceManager.platform)

        return try await versionRepository.report(request: request)
    }
}
