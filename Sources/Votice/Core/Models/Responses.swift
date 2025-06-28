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
    // MARK: - Properties

    public let message: String

    // MARK: - Init

    public init(message: String) {
        self.message = message
    }
}

// MARK: - Suggestion Responses

public struct CreateSuggestionResponse: Codable, Sendable {
    // MARK: - Properties

    public let message: String
    public let id: String

    // MARK: - Init

    public init(message: String, id: String) {
        self.message = message
        self.id = id
    }
}

public struct SuggestionsResponse: Codable, Sendable {
    // MARK: - Properties

    public let suggestions: [SuggestionEntity]

    // MARK: - Init

    public init(suggestions: [SuggestionEntity]) {
        self.suggestions = suggestions
    }
}

public struct VoteSuggestionResponse: Codable, Sendable {
    // MARK: - Properties

    public let message: String
    public let voteStatus: VoteStatusEntity

    // MARK: - Init

    public init(message: String, voteStatus: VoteStatusEntity) {
        self.message = message
        self.voteStatus = voteStatus
    }
}

// MARK: - Comment Responses

public struct CreateCommentResponse: Codable, Sendable {
    // MARK: - Properties

    public let message: String
    public let id: String

    // MARK: - Init

    public init(message: String, id: String) {
        self.message = message
        self.id = id
    }
}

public struct CommentsResponse: Codable, Sendable {
    // MARK: - Properties

    public let comments: [CommentEntity]

    // MARK: - Init

    public init(comments: [CommentEntity]) {
        self.comments = comments
    }
}

// MARK: - Type Aliases for Use Cases

public typealias FetchSuggestionsResponse = SuggestionsResponse
public typealias FetchCommentsResponse = CommentsResponse

// MARK: - Error Response

public struct ErrorResponse: Codable, Sendable {
    // MARK: - Properties

    public let error: String
    public let message: String

    // MARK: - Init

    public init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}
