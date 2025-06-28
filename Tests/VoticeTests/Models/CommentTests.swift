//
//  CommentTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("CommentEntity should initialize correctly")
func testCommentInitialization() async {
    // Given
    let id = "comment-123"
    let suggestionId = "suggestion-456"
    let appId = "app-789"
    let text = "Great idea!"
    let nickname = "Jane"
    let createdBy = "device-123"
    let deviceId = "device-123"
    let createdAt = "2025-06-28T13:25:50.930Z"

    // When
    let comment = CommentEntity(
        id: id,
        suggestionId: suggestionId,
        appId: appId,
        text: text,
        nickname: nickname,
        createdBy: createdBy,
        deviceId: deviceId,
        createdAt: createdAt
    )

    // Then
    #expect(comment.id == id)
    #expect(comment.suggestionId == suggestionId)
    #expect(comment.appId == appId)
    #expect(comment.text == text)
    #expect(comment.nickname == nickname)
    #expect(comment.createdBy == createdBy)
    #expect(comment.deviceId == deviceId)
    #expect(comment.createdAt == createdAt)
}

@Test("CommentEntity should encode and decode correctly")
func testCommentCodable() async throws {
    // Given
    let originalComment = CommentEntity(
        id: "comment-123",
        suggestionId: "suggestion-456",
        appId: "app-789",
        text: "Great idea!",
        nickname: "Jane",
        createdBy: "device-123",
        deviceId: "device-123",
        createdAt: "2025-06-28T13:25:50.930Z"
    )

    // When
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encodedData = try encoder.encode(originalComment)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedComment = try decoder.decode(CommentEntity.self, from: encodedData)

    // Then
    #expect(decodedComment.id == originalComment.id)
    #expect(decodedComment.suggestionId == originalComment.suggestionId)
    #expect(decodedComment.appId == originalComment.appId)
    #expect(decodedComment.text == originalComment.text)
    #expect(decodedComment.nickname == originalComment.nickname)
    #expect(decodedComment.createdBy == originalComment.createdBy)
    #expect(decodedComment.deviceId == originalComment.deviceId)
}

@Test("CommentEntity displayName should work correctly")
func testCommentDisplayName() async {
    // Given & When & Then
    let commentWithNickname = CommentEntity(
        id: "1", suggestionId: "suggestion", appId: "app", text: "text",
        nickname: "John", createdBy: "device", createdAt: Date()
    )
    #expect(commentWithNickname.displayName == "John")

    let commentWithoutNickname = CommentEntity(
        id: "2", suggestionId: "suggestion", appId: "app", text: "text",
        nickname: nil, createdBy: "device", createdAt: Date()
    )
    #expect(commentWithoutNickname.displayName == "Anonymous")

    let commentWithEmptyNickname = CommentEntity(
        id: "3", suggestionId: "suggestion", appId: "app", text: "text",
        nickname: "", createdBy: "device", createdAt: "2025-06-28T13:25:50.930Z"
    )
    #expect(commentWithEmptyNickname.displayName == "")
}

@Test("CommentEntity source detection should work correctly")
func testCommentSourceDetection() async {
    // Given & When
    let sdkComment = CommentEntity(
        id: "1", suggestionId: "suggestion", appId: "app", text: "text",
        createdBy: "device", deviceId: "device-123", createdAt: Date()
    )

    let dashboardComment = CommentEntity(
        id: "2", suggestionId: "suggestion", appId: "app", text: "text",
        createdBy: "user-456", deviceId: nil, createdAt: Date()
    )

    // Then
    #expect(sdkComment.isFromSDK)
    #expect(!sdkComment.isFromDashboard)

    #expect(!dashboardComment.isFromSDK)
    #expect(dashboardComment.isFromDashboard)
}
