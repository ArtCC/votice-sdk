//
//  ConfigurationManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - ConfigurationManager Tests

@Test("ConfigurationManager should initialize with correct defaults")
func testConfigurationManagerInitialization() async {
    // Given
    let manager = ConfigurationManager()

    // Then
    #expect(manager.isConfigured == false)
    #expect(manager.baseURL == "https://us-central1-memorypost-artcc01.cloudfunctions.net/api")
    #expect(manager.apiKey.isEmpty)
    #expect(manager.apiSecret.isEmpty)
    #expect(!manager.configurationId.isEmpty)
}

@Test("ConfigurationManager should configure successfully with valid credentials")
func testConfigurationManagerValidConfiguration() async throws {
    // Given
    let manager = ConfigurationManager()

    // When
    try manager.configure(apiKey: "test-api-key", apiSecret: "test-api-secret")

    // Then
    #expect(manager.isConfigured == true)
    #expect(manager.apiKey == "test-api-key")
    #expect(manager.apiSecret == "test-api-secret")
}

@Test("ConfigurationManager should trim whitespace from credentials")
func testConfigurationManagerTrimsWhitespace() async throws {
    // Given
    let manager = ConfigurationManager()

    // When
    try manager.configure(apiKey: "  test-api-key  ", apiSecret: "  test-api-secret  ")

    // Then
    #expect(manager.apiKey == "test-api-key")
    #expect(manager.apiSecret == "test-api-secret")
}

@Test("ConfigurationManager should throw error for empty API key")
func testConfigurationManagerEmptyAPIKey() async {
    // Given
    let manager = ConfigurationManager()

    // When/Then
    #expect(throws: ConfigurationError.invalidAPIKey) {
        try manager.configure(apiKey: "", apiSecret: "valid-secret")
    }

    #expect(manager.isConfigured == false)
}

@Test("ConfigurationManager should throw error for whitespace-only API key")
func testConfigurationManagerWhitespaceAPIKey() async {
    // Given
    let manager = ConfigurationManager()

    // When/Then
    #expect(throws: ConfigurationError.invalidAPIKey) {
        try manager.configure(apiKey: "   ", apiSecret: "valid-secret")
    }

    #expect(manager.isConfigured == false)
}

@Test("ConfigurationManager should throw error for empty API secret")
func testConfigurationManagerEmptyAPISecret() async {
    // Given
    let manager = ConfigurationManager()

    // When/Then
    #expect(throws: ConfigurationError.invalidAPISecret) {
        try manager.configure(apiKey: "valid-key", apiSecret: "")
    }

    #expect(manager.isConfigured == false)
}

@Test("ConfigurationManager should throw error for whitespace-only API secret")
func testConfigurationManagerWhitespaceAPISecret() async {
    // Given
    let manager = ConfigurationManager()

    // When/Then
    #expect(throws: ConfigurationError.invalidAPISecret) {
        try manager.configure(apiKey: "valid-key", apiSecret: "   ")
    }

    #expect(manager.isConfigured == false)
}

@Test("ConfigurationManager should throw error when already configured")
func testConfigurationManagerAlreadyConfigured() async throws {
    // Given
    let manager = ConfigurationManager()
    try manager.configure(apiKey: "test-key", apiSecret: "test-secret")

    // When/Then
    #expect(throws: ConfigurationError.alreadyConfigured) {
        try manager.configure(apiKey: "new-key", apiSecret: "new-secret")
    }

    // Should maintain original configuration
    #expect(manager.apiKey == "test-key")
    #expect(manager.apiSecret == "test-secret")
}

@Test("ConfigurationManager reset should clear configuration")
func testConfigurationManagerReset() async throws {
    // Given
    let manager = ConfigurationManager()
    try manager.configure(apiKey: "test-key", apiSecret: "test-secret")
    #expect(manager.isConfigured == true)

    // When
    manager.reset()

    // Then
    #expect(manager.isConfigured == false)
    #expect(manager.apiKey.isEmpty)
    #expect(manager.apiSecret.isEmpty)
    #expect(manager.baseURL == "https://us-central1-memorypost-artcc01.cloudfunctions.net/api") // baseURL should remain
}

@Test("ConfigurationManager validateConfiguration should succeed when configured")
func testConfigurationManagerValidateConfigurationSuccess() async throws {
    // Given
    let manager = ConfigurationManager()
    try manager.configure(apiKey: "test-key", apiSecret: "test-secret")

    // When/Then - Should not throw
    try manager.validateConfiguration()
}

@Test("ConfigurationManager validateConfiguration should throw when not configured")
func testConfigurationManagerValidateConfigurationFailure() async {
    // Given
    let manager = ConfigurationManager()

    // When/Then
    #expect(throws: ConfigurationError.notConfigured) {
        try manager.validateConfiguration()
    }
}

@Test("ConfigurationManager should be thread-safe")
func testConfigurationManagerThreadSafety() async throws {
    // Given
    let manager = ConfigurationManager()

    // When - Configure from multiple threads concurrently
    await withTaskGroup(of: Void.self) { group in
        for index in 0..<10 {
            group.addTask {
                do {
                    try manager.configure(apiKey: "key-\(index)", apiSecret: "secret-\(index)")
                } catch {
                    // Expected - only one should succeed
                }
            }
        }
    }

    // Then - Should be configured with one of the values
    #expect(manager.isConfigured == true)
    #expect(!manager.apiKey.isEmpty)
    #expect(!manager.apiSecret.isEmpty)
}

@Test("ConfigurationManager should have unique configuration ID")
func testConfigurationManagerUniqueID() async {
    // Given
    let manager1 = ConfigurationManager()
    let manager2 = ConfigurationManager()

    // When
    let configId1 = manager1.configurationId
    let configId2 = manager2.configurationId

    // Then
    #expect(!configId1.isEmpty)
    #expect(!configId2.isEmpty)
    #expect(configId1.count == 36) // UUID format
    #expect(configId2.count == 36) // UUID format
    #expect(configId1 != configId2) // Each instance should have unique ID

    // Should be consistent across calls on same instance
    #expect(manager1.configurationId == configId1)
    #expect(manager2.configurationId == configId2)
}

// MARK: - ConfigurationError Tests

@Test("ConfigurationError should provide correct descriptions")
func testConfigurationErrorDescriptions() async {
    // Given/When/Then
    #expect(ConfigurationError.alreadyConfigured.errorDescription == "Votice SDK is already configured")
    #expect(
        ConfigurationError
            .notConfigured
            .errorDescription == "Votice SDK is not configured. Call Votice.configure() first"
    )
    #expect(ConfigurationError.invalidAPIKey.errorDescription == "Invalid API key provided")
    #expect(ConfigurationError.invalidAPISecret.errorDescription == "Invalid API secret provided")
}
