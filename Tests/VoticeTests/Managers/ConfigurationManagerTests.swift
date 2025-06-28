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

// MARK: - Test Helper

private func createTestConfigurationManager() -> ConfigurationManager {
    return ConfigurationManager.createForTesting()
}

// MARK: - Tests

@Test("ConfigurationManager should start unconfigured")
func testInitialState() async {
    // Given
    let configManager = createTestConfigurationManager()

    // Then
    #expect(!configManager.isConfigured)
    #expect(configManager.baseURL.isEmpty)
    #expect(configManager.apiKey.isEmpty)
    #expect(configManager.apiSecret.isEmpty)
}

@Test("ConfigurationManager should configure successfully with valid parameters")
func testValidConfiguration() async throws {
    // Given
    let configManager = createTestConfigurationManager()

    let baseURL = "https://api.votice.com"
    let apiKey = "test-api-key"
    let apiSecret = "test-api-secret"

    // When
    try configManager.configure(baseURL: baseURL, apiKey: apiKey, apiSecret: apiSecret)

    // Then
    #expect(configManager.isConfigured)
    #expect(configManager.baseURL == baseURL)
    #expect(configManager.apiKey == apiKey)
    #expect(configManager.apiSecret == apiSecret)
}

@Test("ConfigurationManager should reject invalid base URL")
func testInvalidBaseURL() async {
    // Given
    let configManager = createTestConfigurationManager()

    // When & Then - Empty URL
    do {
        try configManager.configure(baseURL: "", apiKey: "test-key", apiSecret: "test-secret")
        #expect(Bool(false)) // Should not reach here
    } catch ConfigurationError.invalidBaseURL {
        #expect(Bool(true)) // Expected
    } catch {
        #expect(Bool(false)) // Unexpected error
    }

    // Whitespace only URL
    let configManager2 = createTestConfigurationManager()
    do {
        try configManager2.configure(baseURL: "   ", apiKey: "test-key", apiSecret: "test-secret")
        #expect(Bool(false)) // Should not reach here
    } catch ConfigurationError.invalidBaseURL {
        #expect(Bool(true)) // Expected
    } catch {
        #expect(Bool(false)) // Unexpected error
    }
}

@Test("ConfigurationManager should reject empty API key")
func testInvalidAPIKey() async {
    // Given
    let configManager = createTestConfigurationManager()

    // When & Then
    await #expect(throws: ConfigurationError.invalidAPIKey) {
        try configManager.configure(baseURL: "https://api.test.com", apiKey: "", apiSecret: "test-secret")
    }

    let configManager2 = createTestConfigurationManager()
    await #expect(throws: ConfigurationError.invalidAPIKey) {
        try configManager2.configure(baseURL: "https://api.test.com", apiKey: "   ", apiSecret: "test-secret")
    }
}

@Test("ConfigurationManager should reject empty API secret")
func testInvalidAPISecret() async {
    // Given
    let configManager = createTestConfigurationManager()

    // When & Then
    await #expect(throws: ConfigurationError.invalidAPISecret) {
        try configManager.configure(baseURL: "https://api.test.com", apiKey: "test-key", apiSecret: "")
    }

    let configManager2 = createTestConfigurationManager()
    await #expect(throws: ConfigurationError.invalidAPISecret) {
        try configManager2.configure(baseURL: "https://api.test.com", apiKey: "test-key", apiSecret: "   ")
    }
}

@Test("ConfigurationManager should prevent double configuration")
func testDoubleConfiguration() async throws {
    // Given
    let configManager = createTestConfigurationManager()

    // First configuration
    try configManager.configure(
        baseURL: "https://api.test.com",
        apiKey: "test-key",
        apiSecret: "test-secret"
    )

    // When & Then - Second configuration should fail
    await #expect(throws: ConfigurationError.alreadyConfigured) {
        try configManager.configure(
            baseURL: "https://api.test2.com",
            apiKey: "test-key2",
            apiSecret: "test-secret2"
        )
    }
}

@Test("ConfigurationManager should validate configuration correctly")
func testValidateConfiguration() async throws {
    // Given
    let configManager = createTestConfigurationManager()

    // When not configured
    await #expect(throws: ConfigurationError.notConfigured) {
        try configManager.validateConfiguration()
    }

    // When configured
    try configManager.configure(
        baseURL: "https://api.test.com",
        apiKey: "test-key",
        apiSecret: "test-secret"
    )

    // Should not throw
    try configManager.validateConfiguration()
}

@Test("ConfigurationManager should reset successfully")
func testReset() async throws {
    // Given
    let configManager = createTestConfigurationManager()

    try configManager.configure(
        baseURL: "https://api.test.com",
        apiKey: "test-key",
        apiSecret: "test-secret"
    )

    // When
    configManager.reset()

    // Then
    #expect(!configManager.isConfigured)
    #expect(configManager.baseURL.isEmpty)
    #expect(configManager.apiKey.isEmpty)
    #expect(configManager.apiSecret.isEmpty)
}
