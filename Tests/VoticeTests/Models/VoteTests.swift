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
    let id = "vote-123"
    let suggestionId = "suggestion-456"
    let appId = "app-789"
    let voteType = "upvote"
    let createdBy = "user-123"
    let deviceId = "device-456"
    let createdAt = Date()

    // When - SDK vote
    let sdkVote = VoteEntity(
        id: id,
        suggestionId: suggestionId,
        appId: appId,
        voteType: voteType,
        createdBy: createdBy,
        deviceId: deviceId,
        createdAt: createdAt
    )

    // Dashboard vote
    let dashboardVote = VoteEntity(
        id: "vote-789",
        suggestionId: suggestionId,
        appId: appId,
        voteType: "downvote",
        createdBy: "user-123",
        deviceId: nil,
        createdAt: createdAt
    )

    // Then
    #expect(sdkVote.id == id)
    #expect(sdkVote.suggestionId == suggestionId)
    #expect(sdkVote.appId == appId)
    #expect(sdkVote.voteType == voteType)
    #expect(sdkVote.createdBy == createdBy)
    #expect(sdkVote.deviceId == deviceId)
    #expect(sdkVote.createdAt == createdAt)

    #expect(dashboardVote.deviceId == nil)
    #expect(dashboardVote.voteType == "downvote")
}

@Test("VoteEntity should encode and decode correctly")
func testVoteCodable() async throws {
    // Given
    let originalVote = VoteEntity(
        id: "vote-123",
        suggestionId: "suggestion-123",
        appId: "app-456",
        voteType: "upvote",
        createdBy: "user-456",
        deviceId: "device-789",
        createdAt: Date(timeIntervalSince1970: 1640995200)
    )

    // When
    let encoded = try JSONEncoder().encode(originalVote)
    let decoded = try JSONDecoder().decode(VoteEntity.self, from: encoded)

    // Then
    #expect(decoded.id == originalVote.id)
    #expect(decoded.suggestionId == originalVote.suggestionId)
    #expect(decoded.appId == originalVote.appId)
    #expect(decoded.voteType == originalVote.voteType)
    #expect(decoded.createdBy == originalVote.createdBy)
    #expect(decoded.deviceId == originalVote.deviceId)
    #expect(decoded.createdAt.timeIntervalSince1970 == originalVote.createdAt.timeIntervalSince1970)
}

@Test("VoteEntity source detection should work correctly")
func testVoteSourceDetection() async {
    // Given & When
    let sdkVote = VoteEntity(
        id: "vote-1",
        suggestionId: "suggestion",
        appId: "app",
        voteType: "upvote",
        createdBy: "device-123",
        deviceId: "device-123",
        createdAt: Date()
    )

    let dashboardVote = VoteEntity(
        id: "vote-2",
        suggestionId: "suggestion",
        appId: "app",
        voteType: "downvote",
        createdBy: "user-456",
        deviceId: nil,
        createdAt: Date()
    )

    // Then
    #expect(sdkVote.isFromSDK == true)
    #expect(sdkVote.isFromDashboard == false)

    #expect(dashboardVote.isFromSDK == false)
    #expect(dashboardVote.isFromDashboard == true)
}

@Test("VoteStatusEntity should initialize correctly")
func testVoteStatusInitialization() async {
    // Given & When
    let votedStatus = VoteStatusEntity(voted: true, voteType: "upvote")
    let notVotedStatus = VoteStatusEntity(voted: false, voteType: nil)

    // Then
    #expect(votedStatus.voted == true)
    #expect(votedStatus.voteType == "upvote")
    #expect(notVotedStatus.voted == false)
    #expect(notVotedStatus.voteType == nil)
}

@Test("VoteStatusEntity should encode and decode correctly")
func testVoteStatusCodable() async throws {
    // Given
    let originalStatus = VoteStatusEntity(voted: true, voteType: "downvote")

    // When
    let encoded = try JSONEncoder().encode(originalStatus)
    let decoded = try JSONDecoder().decode(VoteStatusEntity.self, from: encoded)

    // Then
    #expect(decoded.voted == originalStatus.voted)
    #expect(decoded.voteType == originalStatus.voteType)
}
