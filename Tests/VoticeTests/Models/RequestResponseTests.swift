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

@Test("CreateSuggestionRequest should encode correctly")
func testCreateSuggestionRequestEncoding() async throws {
    // Given
    let request = CreateSuggestionRequest(
        title: "Dark Mode Support",
        description: "Add dark mode to improve user experience",
        deviceId: "device-123",
        nickname: "John",
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["title"] as? String == "Dark Mode Support")
    #expect(json?["description"] as? String == "Add dark mode to improve user experience")
    #expect(json?["deviceId"] as? String == "device-123")
    #expect(json?["nickname"] as? String == "John")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

@Test("CreateSuggestionRequest should handle optional nickname")
func testCreateSuggestionRequestWithoutNickname() async throws {
    // Given
    let request = CreateSuggestionRequest(
        title: "New Feature",
        description: "Some description",
        deviceId: "device-123",
        nickname: nil,
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["title"] as? String == "New Feature")
    #expect(json?["description"] as? String == "Some description")
    #expect(json?["nickname"] == nil)
}

@Test("FetchSuggestionsRequest should encode correctly")
func testFetchSuggestionsRequestEncoding() async throws {
    // Given
    let request = FetchSuggestionsRequest(
        deviceId: "device-456",
        limit: 10,
        offset: 0,
        status: "pending",
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["deviceId"] as? String == "device-456")
    #expect(json?["limit"] as? Int == 10)
    #expect(json?["offset"] as? Int == 0)
    #expect(json?["status"] as? String == "pending")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

@Test("VoteSuggestionRequest should encode correctly")
func testVoteSuggestionRequestEncoding() async throws {
    // Given
    let request = VoteSuggestionRequest(
        suggestionId: "suggestion-789",
        deviceId: "device-123",
        voteType: .upvote,
        platform: "iOS",
        language: "en"
    )

    // When
    let encodedData = try JSONEncoder().encode(request)
    let json = try JSONSerialization.jsonObject(with: encodedData) as? [String: Any]

    // Then
    #expect(json?["suggestionId"] as? String == "suggestion-789")
    #expect(json?["deviceId"] as? String == "device-123")
    #expect(json?["voteType"] as? String == "upvote")
    #expect(json?["platform"] as? String == "iOS")
    #expect(json?["language"] as? String == "en")
}

// MARK: - Comment Request Tests

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

// MARK: - VoteType Tests

@Test("VoteType should encode and decode correctly")
func testVoteTypeEncodingDecoding() async throws {
    // Given
    let voteTypes: [VoteType] = [.upvote, .downvote, .remove]

    for voteType in voteTypes {
        // When
        let encodedData = try JSONEncoder().encode(voteType)
        let decodedVoteType = try JSONDecoder().decode(VoteType.self, from: encodedData)

        // Then
        #expect(decodedVoteType == voteType)
    }
}

@Test("VoteType raw values should be correct")
func testVoteTypeRawValues() async {
    // Then
    #expect(VoteType.upvote.rawValue == "upvote")
    #expect(VoteType.downvote.rawValue == "downvote")
    #expect(VoteType.remove.rawValue == "remove")
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
    let json = """
    {
        "message": "Vote recorded successfully",
        "voteStatus": {
            "hasVoted": true,
            "voteCount": 15
        }
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(VoteSuggestionResponse.self, from: data)

    // Then
    #expect(response.message == "Vote recorded successfully")
    #expect(response.voteStatus.hasVoted == true)
    #expect(response.voteStatus.voteCount == 15)
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

// MARK: - Type Alias Tests

@Test("FetchSuggestionsResponse alias should work correctly")
func testFetchSuggestionsResponseAlias() async throws {
    // Given
    let json = """
    {
        "suggestions": []
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(FetchSuggestionsResponse.self, from: data)

    // Then
    #expect(response.suggestions.isEmpty)
}

@Test("FetchCommentsResponse alias should work correctly")
func testFetchCommentsResponseAlias() async throws {
    // Given
    let json = """
    {
        "comments": []
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(FetchCommentsResponse.self, from: data)

    // Then
    #expect(response.comments.isEmpty)
}
