//
//  Requests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Suggestion Requests

// MARK: - Create Suggestion Request

struct CreateSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    let title: String
    let description: String
    let deviceId: String
    let nickname: String?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        title: String,
        description: String,
        deviceId: String,
        nickname: String? = nil,
        platform: String,
        language: String
    ) {
        self.title = title
        self.description = description
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
    }
}

// MARK: - Fetch Suggestions Request

struct FetchSuggestionsRequest: Codable, Sendable {
    // MARK: - Properties

    let deviceId: String
    let limit: Int?
    let offset: Int?
    let status: String?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        deviceId: String,
        limit: Int? = nil,
        offset: Int? = nil,
        status: String? = nil,
        platform: String,
        language: String
    ) {
        self.deviceId = deviceId
        self.limit = limit
        self.offset = offset
        self.status = status
        self.platform = platform
        self.language = language
    }
}

// MARK: - Vote Suggestion Request

struct VoteSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    let suggestionId: String
    let deviceId: String
    let voteType: VoteType
    let platform: String
    let language: String
}

// MARK: - Comment Requests

// MARK: - Create Comment Request

struct CreateCommentRequest: Codable, Sendable {
    // MARK: - Properties

    let suggestionId: String
    let content: String
    let deviceId: String
    let nickname: String?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        suggestionId: String,
        content: String,
        deviceId: String,
        nickname: String? = nil,
        platform: String,
        language: String
    ) {
        self.suggestionId = suggestionId
        self.content = content
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
    }
}

// MARK: - Fetch Comments Request

struct FetchCommentsRequest: Codable, Sendable {
    // MARK: - Properties

    let suggestionId: String
    let deviceId: String
    let limit: Int?
    let offset: Int?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        suggestionId: String,
        deviceId: String,
        limit: Int? = nil,
        offset: Int? = nil,
        platform: String,
        language: String
    ) {
        self.suggestionId = suggestionId
        self.deviceId = deviceId
        self.limit = limit
        self.offset = offset
        self.platform = platform
        self.language = language
    }
}

// MARK: - Vote Type

enum VoteType: String, Codable, CaseIterable, Sendable {
    case upvote
    case downvote
    case remove
}
