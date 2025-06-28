//
//  ConfigurationManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

final class ConfigurationManager: ConfigurationManagerProtocol {
    // MARK: - Properties

    static let shared = ConfigurationManager()

    private let lock = NSLock()
    private var _baseURL: String = ""
    private var _apiKey: String = ""
    private var _apiSecret: String = ""
    private var _isConfigured: Bool = false

    // MARK: - Public

    var isConfigured: Bool {
        lock.withLock { _isConfigured }
    }

    var baseURL: String {
        lock.withLock { _baseURL }
    }

    var apiKey: String {
        lock.withLock { _apiKey }
    }

    var apiSecret: String {
        lock.withLock { _apiSecret }
    }

    // MARK: - Initialization

    private init() {}

    // MARK: - Functions

    func configure(baseURL: String, apiKey: String, apiSecret: String) throws {
        try lock.withLock {
            guard !_isConfigured else {
                LogManager.shared.devLog(.warning, "Configuration manager is already configured")
                throw ConfigurationError.alreadyConfigured
            }

            // Validate base URL
            guard !baseURL.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                  URL(string: baseURL) != nil else {
                LogManager.shared.devLog(.error, "Invalid base URL provided: \(baseURL)")
                throw ConfigurationError.invalidBaseURL
            }

            // Validate API key
            guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                LogManager.shared.devLog(.error, "Invalid API key provided")
                throw ConfigurationError.invalidAPIKey
            }

            // Validate API secret
            guard !apiSecret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                LogManager.shared.devLog(.error, "Invalid API secret provided")
                throw ConfigurationError.invalidAPISecret
            }

            _baseURL = baseURL.trimmingCharacters(in: .whitespacesAndNewlines)
            _apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
            _apiSecret = apiSecret.trimmingCharacters(in: .whitespacesAndNewlines)
            _isConfigured = true

            LogManager.shared.devLog(.success, "Configuration manager successfully configured")
        }
    }

    func reset() {
        lock.withLock {
            _baseURL = ""
            _apiKey = ""
            _apiSecret = ""
            _isConfigured = false

            LogManager.shared.devLog(.info, "Configuration manager reset")
        }
    }

    // MARK: - Internal

    func validateConfiguration() throws {
        guard isConfigured else {
            LogManager.shared.devLog(.error, "Configuration manager is not configured")
            throw ConfigurationError.notConfigured
        }
    }
}

// MARK: - Sendable Conformance

extension ConfigurationManager: @unchecked Sendable {}
