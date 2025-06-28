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

// MARK: - Request Tests

@Test("CreateSuggestionRequest should encode correctly")
func testCreateSuggestionRequestEncoding() async throws {
    // Given
    let request = CreateSuggestionRequest(
        deviceId: "device-123",
        text: "Add dark mode support",
        nickname: "John",
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["deviceId"] as? String == "device-123")
    #expect(json?["text"] as? String == "Add dark mode support")
    #expect(json?["nickname"] as? String == "John")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

@Test("CreateCommentRequest should encode correctly")
func testCreateCommentRequestEncoding() async throws {
    // Given
    let request = CreateCommentRequest(
        deviceId: "device-456",
        text: "Great idea!",
        nickname: "Jane"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["deviceId"] as? String == "device-456")
    #expect(json?["text"] as? String == "Great idea!")
    #expect(json?["nickname"] as? String == "Jane")
}

@Test("VoteRequest should encode correctly")
func testVoteRequestEncoding() async throws {
    // Given
    let request = VoteRequest(deviceId: "device-789")

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["deviceId"] as? String == "device-789")
}

// MARK: - Response Tests

@Test("BaseResponse should decode correctly")
func testBaseResponseDecoding() async throws {
    // Given
    let json = """
    {
        "message": "Operation completed successfully"
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(BaseResponse.self, from: data)

    // Then
    #expect(response.message == "Operation completed successfully")
}

@Test("CreateSuggestionResponse should decode correctly")
func testCreateSuggestionResponseDecoding() async throws {
    // Given
    let json = """
    {
        "message": "Suggestion created",
        "id": "suggestion-123"
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(CreateSuggestionResponse.self, from: data)

    // Then
    #expect(response.message == "Suggestion created")
    #expect(response.id == "suggestion-123")
}

@Test("SuggestionsResponse should decode correctly")
func testSuggestionsResponseDecoding() async throws {
    // Given
    let json = """
    {
        "suggestions": [
            {
                "id": "suggestion-1",
                "appId": "app-1",
                "text": "Feature 1",
                "status": "pending",
                "voteCount": 5,
                "commentCount": 2,
                "source": "sdk",
                "createdBy": "device-1",
                "deviceId": "device-1",
                "nickname": "User1",
                "platform": "iOS",
                "language": "en",
                "createdAt": "2024-01-01T00:00:00Z",
                "updatedAt": "2024-01-01T00:00:00Z"
            }
        ]
    }
    """
    let data = Data(json.utf8)

    // When
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let response = try decoder.decode(SuggestionsResponse.self, from: data)

    // Then
    #expect(response.suggestions.count == 1)
    #expect(response.suggestions.first?.id == "suggestion-1")
    #expect(response.suggestions.first?.text == "Feature 1")
    #expect(response.suggestions.first?.status == .pending)
    #expect(response.suggestions.first?.source == .sdk)
}

@Test("CommentsResponse should decode correctly")
func testCommentsResponseDecoding() async throws {
    // Given
    let json = """
    {
        "comments": [
            {
                "id": "comment-1",
                "suggestionId": "suggestion-1",
                "appId": "app-1",
                "text": "Great idea!",
                "nickname": "Jane",
                "createdBy": "device-1",
                "deviceId": "device-1",
                "createdAt": "2024-01-01T00:00:00Z"
            }
        ]
    }
    """
    let data = Data(json.utf8)

    // When
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let response = try decoder.decode(CommentsResponse.self, from: data)

    // Then
    #expect(response.comments.count == 1)
    #expect(response.comments.first?.id == "comment-1")
    #expect(response.comments.first?.text == "Great idea!")
    #expect(response.comments.first?.nickname == "Jane")
}

@Test("ErrorResponse should decode correctly")
func testErrorResponseDecoding() async throws {
    // Given
    let json = """
    {
        "error": "ValidationError",
        "message": "Invalid request parameters"
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(ErrorResponse.self, from: data)

    // Then
    #expect(response.error == "ValidationError")
    #expect(response.message == "Invalid request parameters")
}
