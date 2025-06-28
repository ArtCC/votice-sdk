//
//  Responses.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
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
    public let suggestions: [Suggestion]

    public init(suggestions: [Suggestion]) {
        self.suggestions = suggestions
    }
}

// MARK: - Comment Responses

public struct CommentsResponse: Codable, Sendable {
    public let comments: [Comment]

    public init(comments: [Comment]) {
        self.comments = comments
    }
}

// MARK: - Error Response

public struct ErrorResponse: Codable, Sendable {
    public let error: String
    public let message: String

    public init(error: String, message: String) {
        self.error = error
        self.message = message
    }
}
