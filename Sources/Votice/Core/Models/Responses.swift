//
//  Responses.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Base Response

public struct BaseResponse: Codable, Sendable {
    public let message: String

    public init(message: String) {
        self.message = message
    }
}

// MARK: - Suggestion Responses

public struct CreateSuggestionResponse: Codable, Sendable {
    public let message: String
    public let id: String

    public init(message: String, id: String) {
        self.message = message
        self.id = id
    }
}

public struct SuggestionsResponse: Codable, Sendable {
    public let suggestions: [SuggestionEntity]

    public init(suggestions: [SuggestionEntity]) {
        self.suggestions = suggestions
    }
}

public struct VoteSuggestionResponse: Codable, Sendable {
    public let message: String
    public let voteStatus: VoteStatusEntity

    public init(message: String, voteStatus: VoteStatusEntity) {
        self.message = message
        self.voteStatus = voteStatus
    }
}

// MARK: - Comment Responses

public struct CreateCommentResponse: Codable, Sendable {
    public let message: String
    public let id: String

    public init(message: String, id: String) {
        self.message = message
        self.id = id
    }
}

public struct CommentsResponse: Codable, Sendable {
    public let comments: [CommentEntity]

    public init(comments: [CommentEntity]) {
        self.comments = comments
    }
}

// MARK: - Type Aliases for Use Cases

public typealias FetchSuggestionsResponse = SuggestionsResponse
public typealias FetchCommentsResponse = CommentsResponse

// MARK: - Error Response

public struct ErrorResponse: Codable, Sendable {
    public let error: String
    public let message: String

    public init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}
