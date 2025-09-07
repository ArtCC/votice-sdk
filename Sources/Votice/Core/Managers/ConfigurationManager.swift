//
//  ConfigurationManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol ConfigurationManagerProtocol: Sendable {
    // MARK: - Properties

    var isConfigured: Bool { get }
    var baseURL: String { get }
    var apiKey: String { get }
    var apiSecret: String { get }
    var appId: String { get }
    var commentIsEnabled: Bool { get set }
    var version: String { get }
    var buildNumber: String { get }

    // MARK: - Public functions

    func configure(apiKey: String, apiSecret: String, appId: String) throws
    func reset()
    func validateConfiguration() throws
}

final class ConfigurationManager: ConfigurationManagerProtocol, @unchecked Sendable {
    // MARK: - Properties

    static let shared = ConfigurationManager()

    private var _apiKey = ""
    private var _apiSecret = ""
    private var _appId = ""
    private var _isConfigured = false
    private var _commentIsEnabled = true

    private let lock = NSLock()
    private let _baseURL = "https://api.votice.app/api"
    private let _configurationId = UUID().uuidString
    private let _version = "1.0.8"
    private let _buildNumber = "1"

    // MARK: - Public properties

    var isConfigured: Bool {
        lock.withLock { _isConfigured }
    }

    var baseURL: String {
        _baseURL
    }

    var configurationId: String {
        _configurationId
    }

    var apiKey: String {
        lock.withLock { _apiKey }
    }

    var apiSecret: String {
        lock.withLock { _apiSecret }
    }

    var appId: String {
        lock.withLock { _appId }
    }

    var commentIsEnabled: Bool {
        get {
            lock.withLock { _commentIsEnabled }
        }
        set {
            lock.withLock { _commentIsEnabled = newValue }
        }
    }

    var version: String {
        _version
    }

    var buildNumber: String {
        _buildNumber
    }

    // MARK: - Init

    internal init() {}

    // MARK: - Public functions

    func configure(apiKey: String, apiSecret: String, appId: String) throws {
        try lock.withLock {
            guard !_isConfigured else {
                LogManager.shared.devLog(.warning, "ConfigurationManager: is already configured")

                throw ConfigurationError.alreadyConfigured
            }

            // Validate API key
            guard !apiKey.isEmpty else {
                LogManager.shared.devLog(.error, "ConfigurationManager: invalid API key provided")

                throw ConfigurationError.invalidAPIKey
            }

            // Validate API secret
            guard !apiSecret.isEmpty else {
                LogManager.shared.devLog(.error, "ConfigurationManager: invalid API secret provided")

                throw ConfigurationError.invalidAPISecret
            }

            // Validate app ID
            guard !appId.isEmpty else {
                LogManager.shared.devLog(.error, "ConfigurationManager: invalid app ID provided")

                throw ConfigurationError.invalidAppId
            }

            _apiKey = apiKey
            _apiSecret = apiSecret
            _appId = appId
            _isConfigured = true

            LogManager.shared.devLog(.success, "ConfigurationManager: successfully configured")
        }
    }

    func reset() {
        lock.withLock {
            _apiKey = ""
            _apiSecret = ""
            _appId = ""
            _isConfigured = false
            _commentIsEnabled = true

            LogManager.shared.devLog(.info, "ConfigurationManager: reset")
        }
    }

    func validateConfiguration() throws {
        guard isConfigured else {
            LogManager.shared.devLog(.error, "ConfigurationManager: is not configured")

            throw ConfigurationError.notConfigured
        }
    }
}
