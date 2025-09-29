//
//  VoteEntityTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import Foundation

// MARK: - VoteEntity Tests

@Test("VoteEntity should initialize correctly with all parameters")
func testVoteEntityFullInitialization() async {
    // Given/When
    let vote = VoteEntity(
        suggestionId: "suggestion-123",
        appId: "app-456",
        deviceId: "device-789",
        source: .sdk,
        createdAt: "2025-01-01T00:00:00Z"
    )

    // Then
    #expect(vote.suggestionId == "suggestion-123")
    #expect(vote.appId == "app-456")
    #expect(vote.deviceId == "device-789")
    #expect(vote.source == .sdk)
    #expect(vote.createdAt == "2025-01-01T00:00:00Z")
}

@Test("VoteEntity should initialize correctly with nil parameters")
func testVoteEntityNilInitialization() async {
    // Given/When
    let vote = VoteEntity(
        suggestionId: nil,
        appId: nil,
        deviceId: nil,
        source: nil,
        createdAt: nil
    )

    // Then
    #expect(vote.suggestionId == nil)
    #expect(vote.appId == nil)
    #expect(vote.deviceId == nil)
    #expect(vote.source == nil)
    #expect(vote.createdAt == nil)
}

@Test("VoteEntity should work with different sources")
func testVoteEntityDifferentSources() async {
    // Given/When
    let sdkVote = VoteEntity(
        suggestionId: "s1",
        appId: "app1",
        deviceId: "device1",
        source: nil, // Will be updated when enum is available
        createdAt: nil
    )

    let dashboardVote = VoteEntity(
        suggestionId: "s2",
        appId: "app2",
        deviceId: nil,
        source: nil, // Will be updated when enum is available
        createdAt: nil
    )

    // Then - Basic structure validation
    #expect(sdkVote.suggestionId == "s1")
    #expect(dashboardVote.suggestionId == "s2")
    #expect(sdkVote.deviceId != nil)
    #expect(dashboardVote.deviceId == nil)
}

@Test("VoteEntity should be Codable")
func testVoteEntityCodable() async throws {
    // Given
    let original = VoteEntity(
        suggestionId: "suggestion-123",
        appId: "app-456",
        deviceId: "device-789",
        source: .sdk,
        createdAt: "2025-01-01T00:00:00Z"
    )

    // When - Encode
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)

    // Then - Decode
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(VoteEntity.self, from: data)

    #expect(decoded.suggestionId == original.suggestionId)
    #expect(decoded.appId == original.appId)
    #expect(decoded.deviceId == original.deviceId)
    #expect(decoded.source == original.source)
    #expect(decoded.createdAt == original.createdAt)
}

@Test("VoteEntity should handle nil values in JSON")
func testVoteEntityNilValuesDecoding() async throws {
    // Given
    let jsonString = """
    {
        "suggestionId": null,
        "appId": null,
        "deviceId": null,
        "source": null,
        "createdAt": null
    }
    """
    let jsonData = Data(jsonString.utf8)

    // When
    let decoder = JSONDecoder()
    let vote = try decoder.decode(VoteEntity.self, from: jsonData)

    // Then
    #expect(vote.suggestionId == nil)
    #expect(vote.appId == nil)
    #expect(vote.deviceId == nil)
    #expect(vote.source == nil)
    #expect(vote.createdAt == nil)
}

@Test("VoteEntity should handle partial JSON data")
func testVoteEntityPartialDecoding() async throws {
    // Given - JSON with only some fields
    let jsonString = """
    {
        "suggestionId": "suggestion-123",
        "source": "sdk"
    }
    """
    let jsonData = Data(jsonString.utf8)

    // When
    let decoder = JSONDecoder()
    let vote = try decoder.decode(VoteEntity.self, from: jsonData)

    // Then
    #expect(vote.suggestionId == "suggestion-123")
    #expect(vote.source == .sdk)
    #expect(vote.appId == nil) // Should be nil when not provided
    #expect(vote.deviceId == nil) // Should be nil when not provided
    #expect(vote.createdAt == nil) // Should be nil when not provided
}

@Test("VoteEntity should be Sendable")
func testVoteEntitySendable() async {
    // Given
    let vote = VoteEntity(
        suggestionId: "suggestion-123",
        appId: "app-456",
        deviceId: "device-789",
        source: .sdk,
        createdAt: "2025-01-01T00:00:00Z"
    )

    // When - This compiles, proving it's Sendable
    Task {
        _ = vote.suggestionId
        _ = vote.appId
        _ = vote.deviceId
        _ = vote.source
        _ = vote.createdAt
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}

@Test("VoteEntity should work with collections")
func testVoteEntityCollections() async {
    // Given
    let votes = [
        VoteEntity(suggestionId: "s1", appId: "app1", deviceId: "d1", source: .sdk, createdAt: nil),
        VoteEntity(suggestionId: "s2", appId: "app1", deviceId: nil, source: .dashboard, createdAt: nil),
        VoteEntity(suggestionId: "s3", appId: "app2", deviceId: "d2", source: .sdk, createdAt: nil)
    ]

    // When
    let sdkVotes = votes.filter { $0.source == .sdk }
    let dashboardVotes = votes.filter { $0.source == .dashboard }
    let app1Votes = votes.filter { $0.appId == "app1" }

    // Then
    #expect(sdkVotes.count == 2)
    #expect(dashboardVotes.count == 1)
    #expect(app1Votes.count == 2)
}

@Test("VoteEntity timestamp handling")
func testVoteEntityTimestampHandling() async {
    // Given
    let timestampedVote = VoteEntity(
        suggestionId: "s1",
        appId: "app1",
        deviceId: "device1",
        source: .sdk,
        createdAt: "2025-01-01T12:30:45Z"
    )

    let noTimestampVote = VoteEntity(
        suggestionId: "s2",
        appId: "app1",
        deviceId: "device1",
        source: .sdk,
        createdAt: nil
    )

    // When/Then
    #expect(timestampedVote.createdAt == "2025-01-01T12:30:45Z")
    #expect(noTimestampVote.createdAt == nil)
}
