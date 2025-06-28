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
        "message": "Suggestion created successfully",
        "id": "suggestion-123"
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(CreateSuggestionResponse.self, from: data)

    // Then
    #expect(response.message == "Suggestion created successfully")
    #expect(response.id == "suggestion-123")
}

@Test("CreateCommentResponse should decode correctly")
func testCreateCommentResponseDecoding() async throws {
    // Given
    let json = """
    {
        "message": "Comment created successfully",
        "id": "comment-456"
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(CreateCommentResponse.self, from: data)

    // Then
    #expect(response.message == "Comment created successfully")
    #expect(response.id == "comment-456")
}

@Test("VoteSuggestionResponse should decode correctly")
func testVoteSuggestionResponseDecoding() async throws {
    // Given
    let string = """
    {
        "message": "Vote recorded successfully",
        "voteStatus": {
            "voted": true,
            "voteType": "upvote"
        }
    }
    """
    let json = Data(string.utf8)

    // When
    let response = try JSONDecoder().decode(VoteSuggestionResponse.self, from: json)

    // Then
    #expect(response.message == "Vote recorded successfully")
    #expect(response.voteStatus.voted == true)
    #expect(response.voteStatus.voteType == "upvote")
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
