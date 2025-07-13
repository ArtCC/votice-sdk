//
//  SuggestionEntityTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import Foundation

// MARK: - SuggestionEntity Tests

@Test("SuggestionEntity should initialize with all parameters")
func testSuggestionEntityInitialization() async {
    // Given/When
    let suggestion = SuggestionEntity(
        id: "test-id",
        appId: "test-app",
        title: "Test Title",
        text: "Test Text",
        description: "Test Description",
        nickname: "TestUser",
        createdAt: "2025-01-01T00:00:00Z",
        updatedAt: "2025-01-01T01:00:00Z",
        platform: "iOS",
        createdBy: "user123",
        deviceId: "device123",
        status: .pending,
        source: .sdk,
        commentCount: 5,
        voteCount: 10,
        language: "en"
    )

    // Then
    #expect(suggestion.id == "test-id")
    #expect(suggestion.appId == "test-app")
    #expect(suggestion.title == "Test Title")
    #expect(suggestion.text == "Test Text")
    #expect(suggestion.description == "Test Description")
    #expect(suggestion.nickname == "TestUser")
    #expect(suggestion.createdAt == "2025-01-01T00:00:00Z")
    #expect(suggestion.updatedAt == "2025-01-01T01:00:00Z")
    #expect(suggestion.platform == "iOS")
    #expect(suggestion.createdBy == "user123")
    #expect(suggestion.deviceId == "device123")
    #expect(suggestion.status == .pending)
    #expect(suggestion.source == .sdk)
    #expect(suggestion.commentCount == 5)
    #expect(suggestion.voteCount == 10)
    #expect(suggestion.language == "en")
}

@Test("SuggestionEntity should initialize with minimal parameters")
func testSuggestionEntityMinimalInitialization() async {
    // Given/When
    let suggestion = SuggestionEntity(id: "minimal-id")

    // Then
    #expect(suggestion.id == "minimal-id")
    #expect(suggestion.appId == nil)
    #expect(suggestion.title == nil)
    #expect(suggestion.text == nil)
    #expect(suggestion.description == nil)
    #expect(suggestion.nickname == nil)
    #expect(suggestion.createdAt == nil)
    #expect(suggestion.updatedAt == nil)
    #expect(suggestion.platform == nil)
    #expect(suggestion.createdBy == nil)
    #expect(suggestion.deviceId == nil)
    #expect(suggestion.status == nil)
    #expect(suggestion.source == nil)
    #expect(suggestion.commentCount == nil)
    #expect(suggestion.voteCount == nil)
    #expect(suggestion.language == nil)
}

@Test("SuggestionEntity displayText should return correct value")
func testSuggestionEntityDisplayText() async {
    // Given/When/Then
    // When text is available
    let suggestionWithText = SuggestionEntity(id: "1", text: "SDK Text")
    #expect(suggestionWithText.displayText == "SDK Text")

    // When only title is available (text is nil)
    let suggestionWithTitle = SuggestionEntity(id: "2", title: "Dashboard Title")
    #expect(suggestionWithTitle.displayText == "Dashboard Title")

    // When both text and title are available (text takes precedence)
    let suggestionWithBoth = SuggestionEntity(id: "3", title: "Title", text: "Text")
    #expect(suggestionWithBoth.displayText == "Text")

    // When neither text nor title are available
    let suggestionEmpty = SuggestionEntity(id: "4")
    #expect(suggestionEmpty.displayText == "")
}

@Test("SuggestionEntity source detection should work correctly")
func testSuggestionEntitySourceDetection() async {
    // Given/When/Then
    // SDK source
    let sdkSuggestion = SuggestionEntity(id: "1", source: .sdk)
    #expect(sdkSuggestion.isFromSDK == true)
    #expect(sdkSuggestion.isFromDashboard == false)

    // Dashboard source
    let dashboardSuggestion = SuggestionEntity(id: "2", source: .dashboard)
    #expect(dashboardSuggestion.isFromSDK == false)
    #expect(dashboardSuggestion.isFromDashboard == true)

    // No source
    let noSourceSuggestion = SuggestionEntity(id: "3")
    #expect(noSourceSuggestion.isFromSDK == false)
    #expect(noSourceSuggestion.isFromDashboard == false)
}

@Test("SuggestionEntity canBeVoted should work correctly")
func testSuggestionEntityCanBeVoted() async {
    // Given/When/Then
    // Votable statuses
    let pendingSuggestion = SuggestionEntity(id: "1", status: .pending)
    #expect(pendingSuggestion.canBeVoted == true)

    let acceptedSuggestion = SuggestionEntity(id: "2", status: .accepted)
    #expect(acceptedSuggestion.canBeVoted == true)

    let inProgressSuggestion = SuggestionEntity(id: "3", status: .inProgress)
    #expect(inProgressSuggestion.canBeVoted == true)

    // Non-votable statuses
    let completedSuggestion = SuggestionEntity(id: "4", status: .completed)
    #expect(completedSuggestion.canBeVoted == false)

    let rejectedSuggestion = SuggestionEntity(id: "5", status: .rejected)
    #expect(rejectedSuggestion.canBeVoted == false)

    // No status
    let noStatusSuggestion = SuggestionEntity(id: "6")
    #expect(noStatusSuggestion.canBeVoted == false)
}

@Test("SuggestionEntity copyWith should work correctly")
func testSuggestionEntityCopyWith() async {
    // Given
    let original = SuggestionEntity(
        id: "original-id",
        appId: "original-app",
        title: "Original Title",
        text: "Original Text",
        status: .pending,
        source: .sdk,
        voteCount: 5
    )

    // When
    let copied = original.copyWith(
        id: "new-id",
        title: "New Title",
        voteCount: 10
    )

    // Then
    #expect(copied.id == "new-id") // Changed
    #expect(copied.appId == "original-app") // Unchanged
    #expect(copied.title == "New Title") // Changed
    #expect(copied.text == "Original Text") // Unchanged
    #expect(copied.status == .pending) // Unchanged
    #expect(copied.source == .sdk) // Unchanged
    #expect(copied.voteCount == 10) // Changed
}

@Test("SuggestionEntity should be Equatable")
func testSuggestionEntityEquatable() async {
    // Given
    let suggestion1 = SuggestionEntity(
        id: "test-id",
        title: "Test Title",
        status: .pending
    )
    let suggestion2 = SuggestionEntity(
        id: "test-id",
        title: "Test Title",
        status: .pending
    )
    let suggestion3 = SuggestionEntity(
        id: "different-id",
        title: "Test Title",
        status: .pending
    )

    // When/Then
    #expect(suggestion1 == suggestion2) // Same content
    #expect(suggestion1 != suggestion3) // Different ID
}

@Test("SuggestionEntity should be Identifiable")
func testSuggestionEntityIdentifiable() async {
    // Given
    let suggestion = SuggestionEntity(id: "test-id")

    // When/Then
    #expect(suggestion.id == "test-id")

    // Should work in contexts that require Identifiable
    let suggestions = [suggestion]
    let ids = suggestions.map(\.id)
    #expect(ids == ["test-id"])
}

@Test("SuggestionEntity should be Codable")
func testSuggestionEntityCodable() async throws {
    // Given
    let original = SuggestionEntity(
        id: "test-id",
        appId: "test-app",
        title: "Test Title",
        text: "Test Text",
        description: "Test Description",
        nickname: "TestUser",
        createdAt: "2025-01-01T00:00:00Z",
        updatedAt: "2025-01-01T01:00:00Z",
        platform: "iOS",
        createdBy: "user123",
        deviceId: "device123",
        status: .pending,
        source: .sdk,
        commentCount: 5,
        voteCount: 10,
        language: "en"
    )

    // When - Encode
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)

    // Then - Decode
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(SuggestionEntity.self, from: data)

    #expect(decoded == original)
    #expect(decoded.id == original.id)
    #expect(decoded.appId == original.appId)
    #expect(decoded.title == original.title)
    #expect(decoded.text == original.text)
    #expect(decoded.description == original.description)
    #expect(decoded.nickname == original.nickname)
    #expect(decoded.createdAt == original.createdAt)
    #expect(decoded.updatedAt == original.updatedAt)
    #expect(decoded.platform == original.platform)
    #expect(decoded.createdBy == original.createdBy)
    #expect(decoded.deviceId == original.deviceId)
    #expect(decoded.status == original.status)
    #expect(decoded.source == original.source)
    #expect(decoded.commentCount == original.commentCount)
    #expect(decoded.voteCount == original.voteCount)
    #expect(decoded.language == original.language)
}

@Test("SuggestionEntity should be Sendable")
func testSuggestionEntitySendable() async {
    // Given
    let suggestion = SuggestionEntity(
        id: "test-id",
        title: "Test Title",
        status: .pending
    )

    // When - This compiles, proving it's Sendable
    Task {
        _ = suggestion.id
        _ = suggestion.title
        _ = suggestion.displayText
        _ = suggestion.isFromSDK
        _ = suggestion.canBeVoted
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}
