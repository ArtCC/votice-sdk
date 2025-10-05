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
    private nonisolated(unsafe) let userDefaults: UserDefaults
    private let lastReportKey = "Votice_LastVersionReportDate"
    private let reportInterval: TimeInterval = 60 * 60 * 24 * 3 // 3 days

    // MARK: - Init

    init(versionRepository: VersionRepositoryProtocol = VersionRepository(),
         configurationManager: ConfigurationManagerProtocol = ConfigurationManager.shared,
         deviceManager: DeviceManagerProtocol = DeviceManager.shared,
         userDefaults: UserDefaults = .standard) {
        self.versionRepository = versionRepository
        self.configurationManager = configurationManager
        self.deviceManager = deviceManager
        self.userDefaults = userDefaults
    }

    // MARK: - VersionUseCaseProtocol

    func report() async throws -> VersionResponse {
        let now = Date()

        if let lastReport = userDefaults.object(forKey: lastReportKey) as? Date,
           now.timeIntervalSince(lastReport) < reportInterval {
            throw VersionReportError.tooSoon
        }

        try configurationManager.validateConfiguration()

        let request: VersionRequest = .init(
            version: configurationManager.version,
            buildNumber: configurationManager.buildNumber,
            platform: deviceManager.platform
        )
        let response = try await versionRepository.report(request: request)

        userDefaults.set(now, forKey: lastReportKey)

        return response
    }
}
