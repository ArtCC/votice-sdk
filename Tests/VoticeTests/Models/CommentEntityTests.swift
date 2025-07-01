//
//  CommentEntityTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - CommentEntity Tests

@Test("CommentEntity should initialize correctly")
func testCommentEntityInitialization() async {
    // Given/When
    let comment = CommentEntity(
        id: "comment-id",
        suggestionId: "suggestion-id",
        appId: "app-id",
        text: "This is a test comment",
        createdAt: "2025-01-01T00:00:00Z",
        updatedAt: "2025-01-01T01:00:00Z",
        createdBy: "user123",
        deviceId: "device123",
        nickname: "TestUser",
        source: "sdk"
    )

    // Then
    #expect(comment.id == "comment-id")
    #expect(comment.suggestionId == "suggestion-id")
    #expect(comment.appId == "app-id")
    #expect(comment.text == "This is a test comment")
    #expect(comment.createdAt == "2025-01-01T00:00:00Z")
    #expect(comment.updatedAt == "2025-01-01T01:00:00Z")
    #expect(comment.createdBy == "user123")
    #expect(comment.deviceId == "device123")
    #expect(comment.nickname == "TestUser")
    #expect(comment.source == "sdk")
}

@Test("CommentEntity displayName should return correct value")
func testCommentEntityDisplayName() async {
    // Given/When/Then
    // When nickname is available
    let commentWithNickname = CommentEntity(
        id: "1",
        suggestionId: "s1",
        appId: "app1",
        text: "Comment text",
        nickname: "TestUser"
    )
    #expect(commentWithNickname.displayName == "TestUser")

    // When nickname is nil
    let commentWithoutNickname = CommentEntity(
        id: "2",
        suggestionId: "s1",
        appId: "app1",
        text: "Comment text",
        nickname: nil
    )
    #expect(commentWithoutNickname.displayName == "Anonymous")

    // When nickname is empty string
    let commentWithEmptyNickname = CommentEntity(
        id: "3",
        suggestionId: "s1",
        appId: "app1",
        text: "Comment text",
        nickname: ""
    )
    #expect(commentWithEmptyNickname.displayName == "") // Empty string takes precedence over nil
}

@Test("CommentEntity source detection should work correctly")
func testCommentEntitySourceDetection() async {
    // Given/When/Then
    // From SDK (has deviceId)
    let sdkComment = CommentEntity(
        id: "1",
        suggestionId: "s1",
        appId: "app1",
        text: "SDK comment",
        deviceId: "device123"
    )
    #expect(sdkComment.isFromSDK == true)
    #expect(sdkComment.isFromDashboard == false)

    // From Dashboard (no deviceId)
    let dashboardComment = CommentEntity(
        id: "2",
        suggestionId: "s1",
        appId: "app1",
        text: "Dashboard comment",
        createdBy: "user123",
        deviceId: nil
    )
    #expect(dashboardComment.isFromSDK == false)
    #expect(dashboardComment.isFromDashboard == true)

    // Edge case: empty deviceId string
    let emptyDeviceComment = CommentEntity(
        id: "3",
        suggestionId: "s1",
        appId: "app1",
        text: "Comment",
        deviceId: ""
    )
    #expect(emptyDeviceComment.isFromSDK == true) // Empty string is still considered "not nil"
    #expect(emptyDeviceComment.isFromDashboard == false)
}

@Test("CommentEntity should be Identifiable")
func testCommentEntityIdentifiable() async {
    // Given
    let comment = CommentEntity(
        id: "test-id",
        suggestionId: "s1",
        appId: "app1",
        text: "Test comment"
    )

    // When/Then
    #expect(comment.id == "test-id")

    // Should work in contexts that require Identifiable
    let comments = [comment]
    let ids = comments.map(\.id)
    #expect(ids == ["test-id"])
}

@Test("CommentEntity should be Codable")
func testCommentEntityCodable() async throws {
    // Given
    let original = CommentEntity(
        id: "comment-id",
        suggestionId: "suggestion-id",
        appId: "app-id",
        text: "This is a test comment",
        createdAt: "2025-01-01T00:00:00Z",
        updatedAt: "2025-01-01T01:00:00Z",
        createdBy: "user123",
        deviceId: "device123",
        nickname: "TestUser",
        source: "sdk"
    )

    // When - Encode
    let encoder = JSONEncoder()
    let data = try encoder.encode(original)

    // Then - Decode
    let decoder = JSONDecoder()
    let decoded = try decoder.decode(CommentEntity.self, from: data)

    #expect(decoded.id == original.id)
    #expect(decoded.suggestionId == original.suggestionId)
    #expect(decoded.appId == original.appId)
    #expect(decoded.text == original.text)
    #expect(decoded.createdAt == original.createdAt)
    #expect(decoded.updatedAt == original.updatedAt)
    #expect(decoded.createdBy == original.createdBy)
    #expect(decoded.deviceId == original.deviceId)
    #expect(decoded.nickname == original.nickname)
    #expect(decoded.source == original.source)
}

@Test("CommentEntity should handle nil optional values in JSON")
func testCommentEntityNilValuesDecoding() async throws {
    // Given
    let jsonString = """
    {
        "id": "comment-id",
        "suggestionId": "suggestion-id",
        "appId": "app-id",
        "text": "Test comment",
        "createdAt": null,
        "updatedAt": null,
        "createdBy": null,
        "deviceId": null,
        "nickname": null,
        "source": null
    }
    """
    let jsonData = Data(jsonString.utf8)

    // When
    let decoder = JSONDecoder()
    let comment = try decoder.decode(CommentEntity.self, from: jsonData)

    // Then
    #expect(comment.id == "comment-id")
    #expect(comment.suggestionId == "suggestion-id")
    #expect(comment.appId == "app-id")
    #expect(comment.text == "Test comment")
    #expect(comment.createdAt == nil)
    #expect(comment.updatedAt == nil)
    #expect(comment.createdBy == nil)
    #expect(comment.deviceId == nil)
    #expect(comment.nickname == nil)
    #expect(comment.source == nil)
}

@Test("CommentEntity should be Sendable")
func testCommentEntitySendable() async {
    // Given
    let comment = CommentEntity(
        id: "test-id",
        suggestionId: "s1",
        appId: "app1",
        text: "Test comment",
        nickname: "TestUser"
    )

    // When - This compiles, proving it's Sendable
    Task {
        _ = comment.id
        _ = comment.text
        _ = comment.displayName
        _ = comment.isFromSDK
        _ = comment.isFromDashboard
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}

@Test("CommentEntity should work with different combinations of fields")
func testCommentEntityFieldCombinations() async {
    // Given/When/Then
    // SDK comment with nickname
    let sdkCommentWithNickname = CommentEntity(
        id: "1",
        suggestionId: "s1",
        appId: "app1",
        text: "SDK comment",
        deviceId: "device123",
        nickname: "SDKUser"
    )
    #expect(sdkCommentWithNickname.isFromSDK == true)
    #expect(sdkCommentWithNickname.displayName == "SDKUser")

    // SDK comment without nickname
    let sdkCommentAnonymous = CommentEntity(
        id: "2",
        suggestionId: "s1",
        appId: "app1",
        text: "Anonymous SDK comment",
        deviceId: "device456",
        nickname: nil
    )
    #expect(sdkCommentAnonymous.isFromSDK == true)
    #expect(sdkCommentAnonymous.displayName == "Anonymous")

    // Dashboard comment with createdBy
    let dashboardComment = CommentEntity(
        id: "3",
        suggestionId: "s1",
        appId: "app1",
        text: "Dashboard comment",
        createdBy: "admin123",
        deviceId: nil
    )
    #expect(dashboardComment.isFromDashboard == true)
    #expect(dashboardComment.displayName == "Anonymous") // No nickname, so Anonymous
}
