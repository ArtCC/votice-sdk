//
//  VoticeErrorTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - VoticeError Tests

@Test("VoticeError invalidInput should provide correct description")
func testVoticeErrorInvalidInput() async {
    // Given
    let error = VoticeError.invalidInput("Title cannot be empty")
    
    // Then
    #expect(error.errorDescription == "Invalid input: Title cannot be empty")
}

@Test("VoticeError networkError should provide correct description")
func testVoticeErrorNetworkError() async {
    // Given
    let underlyingError = NSError(domain: "NetworkDomain", code: 500, userInfo: [NSLocalizedDescriptionKey: "Server error"])
    let error = VoticeError.networkError(underlyingError)
    
    // Then
    #expect(error.errorDescription == "Network error: Server error")
}

@Test("VoticeError configurationError should provide correct description")
func testVoticeErrorConfigurationError() async {
    // Given
    let configError = ConfigurationError.notConfigured
    let error = VoticeError.configurationError(configError)
    
    // Then
    #expect(error.errorDescription == configError.errorDescription)
}

@Test("VoticeError unknownError should provide correct description")
func testVoticeErrorUnknownError() async {
    // Given
    let error = VoticeError.unknownError("Something unexpected happened")
    
    // Then
    #expect(error.errorDescription == "Unknown error: Something unexpected happened")
}

@Test("VoticeError should be Sendable")
func testVoticeErrorSendable() async {
    // Given
    let error = VoticeError.invalidInput("Test")
    
    // When - This compiles, proving it's Sendable
    Task {
        let _ = error
    }
    
    // Then - No assertion needed, compilation proves Sendable conformance
}

@Test("VoticeError should conform to LocalizedError")
func testVoticeErrorLocalizedError() async {
    // Given
    let error = VoticeError.invalidInput("Test message")
    
    // When
    let localizedError = error as LocalizedError
    
    // Then
    #expect(localizedError.errorDescription != nil)
}