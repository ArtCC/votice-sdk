//
//  Responses.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Base Response

struct BaseResponse: Codable, Sendable {
    // MARK: - Properties

    let message: String
}

// MARK: - Suggestion Responses

struct CreateSuggestionResponse: Codable, Sendable {
    // MARK: - Properties

    let message: String
    let id: String
}

struct SuggestionsResponse: Codable, Sendable {
    // MARK: - Properties

    let suggestions: [SuggestionEntity]
}

struct VoteSuggestionResponse: Codable, Sendable {
    // MARK: - Properties

    let message: String
    let voteStatus: VoteStatusEntity
}

// MARK: - Comment Responses

struct CreateCommentResponse: Codable, Sendable {
    // MARK: - Properties

    let message: String
    let id: String
}

struct CommentsResponse: Codable, Sendable {
    // MARK: - Properties

    let comments: [CommentEntity]
}

// MARK: - Error Response

struct ErrorResponse: Codable, Sendable {
    // MARK: - Properties

    let error: String
    let message: String
}

// MARK: - Type Aliases

typealias FetchSuggestionsResponse = SuggestionsResponse
typealias FetchCommentsResponse = CommentsResponse
