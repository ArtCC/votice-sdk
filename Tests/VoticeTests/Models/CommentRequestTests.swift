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

@Test("CreateCommentRequest should encode correctly")
func testCreateCommentRequestEncoding() async throws {
    // Given
    let request = CreateCommentRequest(
        suggestionId: "suggestion-456",
        content: "Great idea! This would be very useful.",
        deviceId: "device-789",
        nickname: "Jane",
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["suggestionId"] as? String == "suggestion-456")
    #expect(json?["content"] as? String == "Great idea! This would be very useful.")
    #expect(json?["deviceId"] as? String == "device-789")
    #expect(json?["nickname"] as? String == "Jane")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

@Test("FetchCommentsRequest should encode correctly")
func testFetchCommentsRequestEncoding() async throws {
    // Given
    let request = FetchCommentsRequest(
        suggestionId: "suggestion-123",
        deviceId: "device-456",
        limit: 20,
        offset: 5,
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["suggestionId"] as? String == "suggestion-123")
    #expect(json?["deviceId"] as? String == "device-456")
    #expect(json?["limit"] as? Int == 20)
    #expect(json?["offset"] as? Int == 5)
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}
