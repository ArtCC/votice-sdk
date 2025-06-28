//
//  SuggestionTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("SuggestionEntity should initialize correctly")
func testSuggestionInitialization() async {
    // Given
    let id = "suggestion-123"
    let appId = "app-456"
    let text = "Add dark mode support"
    let status = SuggestionStatus.pending
    let source = SuggestionSource.sdk
    let createdBy = "device-789"
    let nickname = "John"
    let platform = "iOS"
    let language = "en"
    let createdAt = Date()
    let updatedAt = Date()

    // When
    let suggestion = SuggestionEntity(
        id: id,
        appId: appId,
        text: text,
        status: status,
        voteCount: 5,
        commentCount: 3,
        source: source,
        createdBy: createdBy,
        deviceId: "device-789",
        nickname: nickname,
        platform: platform,
        language: language,
        createdAt: createdAt,
        updatedAt: updatedAt
    )

    // Then
    #expect(suggestion.id == id)
    #expect(suggestion.appId == appId)
    #expect(suggestion.text == text)
    #expect(suggestion.status == status)
    #expect(suggestion.voteCount == 5)
    #expect(suggestion.commentCount == 3)
    #expect(suggestion.source == source)
    #expect(suggestion.createdBy == createdBy)
    #expect(suggestion.deviceId == "device-789")
    #expect(suggestion.nickname == nickname)
    #expect(suggestion.platform == platform)
    #expect(suggestion.language == language)
}

@Test("SuggestionEntity should encode and decode correctly")
func testSuggestionCodable() async throws {
    // Given
    let originalSuggestion = SuggestionEntity(
        id: "suggestion-123",
        appId: "app-456",
        text: "Add dark mode support",
        status: .pending,
        voteCount: 5,
        commentCount: 3,
        source: .sdk,
        createdBy: "device-789",
        deviceId: "device-789",
        nickname: "John",
        platform: "iOS",
        language: "en",
        createdAt: Date(timeIntervalSince1970: 1640995200), // Fixed date for testing
        updatedAt: Date(timeIntervalSince1970: 1640995200)
    )

    // When
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encodedData = try encoder.encode(originalSuggestion)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedSuggestion = try decoder.decode(SuggestionEntity.self, from: encodedData)

    // Then
    #expect(decodedSuggestion.id == originalSuggestion.id)
    #expect(decodedSuggestion.appId == originalSuggestion.appId)
    #expect(decodedSuggestion.text == originalSuggestion.text)
    #expect(decodedSuggestion.status == originalSuggestion.status)
    #expect(decodedSuggestion.source == originalSuggestion.source)
    #expect(decodedSuggestion.nickname == originalSuggestion.nickname)
    #expect(decodedSuggestion.platform == originalSuggestion.platform)
}

@Test("SuggestionEntity displayText should work correctly")
func testSuggestionDisplayText() async {
    // Given & When & Then
    let sdkSuggestion = SuggestionEntity(
        id: "1", appId: "app", text: "SDK text", status: .pending,
        voteCount: 0, commentCount: 0, source: .sdk, createdBy: "device",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(sdkSuggestion.displayText == "SDK text")

    let dashboardSuggestion = SuggestionEntity(
        id: "2", appId: "app", title: "Dashboard title", status: .pending,
        voteCount: 0, commentCount: 0, source: .dashboard, createdBy: "user",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(dashboardSuggestion.displayText == "Dashboard title")

    let emptySuggestion = SuggestionEntity(
        id: "3", appId: "app", status: .pending,
        voteCount: 0, commentCount: 0, source: .sdk, createdBy: "device",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(emptySuggestion.displayText == "")
}

@Test("SuggestionEntity source detection should work correctly")
func testSuggestionSourceDetection() async {
    // Given & When
    let sdkSuggestion = SuggestionEntity(
        id: "1", appId: "app", text: "text", status: .pending,
        voteCount: 0, commentCount: 0, source: .sdk, createdBy: "device",
        createdAt: Date(), updatedAt: Date()
    )

    let dashboardSuggestion = SuggestionEntity(
        id: "2", appId: "app", title: "title", status: .pending,
        voteCount: 0, commentCount: 0, source: .dashboard, createdBy: "user",
        createdAt: Date(), updatedAt: Date()
    )

    // Then
    #expect(sdkSuggestion.isFromSDK)
    #expect(!sdkSuggestion.isFromDashboard)

    #expect(!dashboardSuggestion.isFromSDK)
    #expect(dashboardSuggestion.isFromDashboard)
}

@Test("SuggestionEntity voting eligibility should work correctly")
func testSuggestionVotingEligibility() async {
    let votableStatuses: [SuggestionStatus] = [.pending, .accepted, .inProgress]
    let nonVotableStatuses: [SuggestionStatus] = [.completed, .rejected]

    // Test votable statuses
    for status in votableStatuses {
        let suggestion = SuggestionEntity(
            id: "1", appId: "app", text: "text", status: status,
            voteCount: 0, commentCount: 0, source: .sdk, createdBy: "device",
            createdAt: Date(), updatedAt: Date()
        )
        #expect(suggestion.canBeVoted)
    }

    // Test non-votable statuses
    for status in nonVotableStatuses {
        let suggestion = SuggestionEntity(
            id: "1", appId: "app", text: "text", status: status,
            voteCount: 0, commentCount: 0, source: .sdk, createdBy: "device",
            createdAt: Date(), updatedAt: Date()
        )
        #expect(!suggestion.canBeVoted)
    }
}

@Test("SuggestionStatus should have all expected cases")
func testSuggestionStatusCases() async {
    let expectedStatuses: [SuggestionStatus] = [.pending, .accepted, .inProgress, .completed, .rejected]

    #expect(SuggestionStatus.allCases.count == 5)

    for status in expectedStatuses {
        #expect(SuggestionStatus.allCases.contains(status))
    }
}

@Test("SuggestionSource should have all expected cases")
func testSuggestionSourceCases() async {
    let expectedSources: [SuggestionSource] = [.dashboard, .sdk]

    #expect(SuggestionSource.allCases.count == 2)

    for source in expectedSources {
        #expect(SuggestionSource.allCases.contains(source))
    }
}
