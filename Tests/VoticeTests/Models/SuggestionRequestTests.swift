//
//  RequestResponseTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - Suggestion Request Tests

@Test("CreateSuggestionRequest should encode correctly")
func testCreateSuggestionRequestEncoding() async throws {
    // Given
    let request = CreateSuggestionRequest(
        title: "Dark Mode Support",
        description: "Add dark mode to improve user experience",
        deviceId: "device-123",
        nickname: "John",
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["title"] as? String == "Dark Mode Support")
    #expect(json?["description"] as? String == "Add dark mode to improve user experience")
    #expect(json?["deviceId"] as? String == "device-123")
    #expect(json?["nickname"] as? String == "John")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

@Test("CreateSuggestionRequest should handle optional nickname")
func testCreateSuggestionRequestWithoutNickname() async throws {
    // Given
    let request = CreateSuggestionRequest(
        title: "New Feature",
        description: "Some description",
        deviceId: "device-123",
        nickname: nil,
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["title"] as? String == "New Feature")
    #expect(json?["description"] as? String == "Some description")
    #expect(json?["nickname"] == nil)
}

@Test("FetchSuggestionsRequest should encode correctly")
func testFetchSuggestionsRequestEncoding() async throws {
    // Given
    let request = FetchSuggestionsRequest(appId: "device-456")

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["appId"] as? String == "device-456")
}

@Test("VoteSuggestionRequest should encode correctly")
func testVoteSuggestionRequestEncoding() async throws {
    // Given
    let request = VoteSuggestionRequest(
        suggestionId: "suggestion-789",
        deviceId: "device-123",
        voteType: .upvote,
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["suggestionId"] as? String == "suggestion-789")
    #expect(json?["deviceId"] as? String == "device-123")
    #expect(json?["voteType"] as? String == "upvote")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}
