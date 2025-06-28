//
//  VoteTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("VoteEntity should initialize correctly")
func testVoteInitialization() async {
    // Given
    let suggestionId = "suggestion-123"
    let userId = "user-456"
    let deviceId = "device-789"
    let createdAt = Date()

    // When - SDK vote
    let sdkVote = VoteEntity(
        suggestionId: suggestionId,
        deviceId: deviceId,
        createdAt: createdAt
    )

    // Dashboard vote
    let dashboardVote = VoteEntity(
        suggestionId: suggestionId,
        userId: userId,
        createdAt: createdAt
    )

    // Then
    #expect(sdkVote.suggestionId == suggestionId)
    #expect(sdkVote.deviceId == deviceId)
    #expect(sdkVote.userId == nil)
    #expect(sdkVote.createdAt == createdAt)

    #expect(dashboardVote.suggestionId == suggestionId)
    #expect(dashboardVote.userId == userId)
    #expect(dashboardVote.deviceId == nil)
    #expect(dashboardVote.createdAt == createdAt)
}

@Test("VoteEntity should encode and decode correctly")
func testVoteCodable() async throws {
    // Given
    let originalVote = VoteEntity(
        suggestionId: "suggestion-123",
        userId: "user-456",
        deviceId: nil,
        createdAt: Date(timeIntervalSince1970: 1640995200)
    )

    // When
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encodedData = try encoder.encode(originalVote)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedVote = try decoder.decode(VoteEntity.self, from: encodedData)

    // Then
    #expect(decodedVote.suggestionId == originalVote.suggestionId)
    #expect(decodedVote.userId == originalVote.userId)
    #expect(decodedVote.deviceId == originalVote.deviceId)
}

@Test("VoteEntity source detection should work correctly")
func testVoteSourceDetection() async {
    // Given & When
    let sdkVote = VoteEntity(
        suggestionId: "suggestion",
        deviceId: "device-123",
        createdAt: Date()
    )

    let dashboardVote = VoteEntity(
        suggestionId: "suggestion",
        userId: "user-456",
        createdAt: Date()
    )

    // Then
    #expect(sdkVote.isFromSDK)
    #expect(!sdkVote.isFromDashboard)

    #expect(!dashboardVote.isFromSDK)
    #expect(dashboardVote.isFromDashboard)
}

@Test("VoteStatusEntity should initialize correctly")
func testVoteStatusInitialization() async {
    // Given & When
    let votedStatus = VoteStatusEntity(hasVoted: true, voteCount: 10)
    let notVotedStatus = VoteStatusEntity(hasVoted: false, voteCount: 5)

    // Then
    #expect(votedStatus.hasVoted)
    #expect(votedStatus.voteCount == 10)

    #expect(!notVotedStatus.hasVoted)
    #expect(notVotedStatus.voteCount == 5)
}

@Test("VoteStatusEntity should encode and decode correctly")
func testVoteStatusCodable() async throws {
    // Given
    let originalStatus = VoteStatusEntity(hasVoted: true, voteCount: 42)

    // When
    let encodedData = try JSONEncoder().encode(originalStatus)
    let decodedStatus = try JSONDecoder().decode(VoteStatusEntity.self, from: encodedData)

    // Then
    #expect(decodedStatus.hasVoted == originalStatus.hasVoted)
    #expect(decodedStatus.voteCount == originalStatus.voteCount)
}
