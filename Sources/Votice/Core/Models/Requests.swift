//
//  Requests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Suggestion Requests

public struct CreateSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    public let title: String
    public let description: String
    public let deviceId: String
    public let nickname: String?
    public let platform: String
    public let language: String

    // MARK: - Init

    public init(
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

public struct FetchSuggestionsRequest: Codable, Sendable {
    // MARK: - Properties

    public let deviceId: String
    public let limit: Int?
    public let offset: Int?
    public let status: String?
    public let platform: String
    public let language: String

    // MARK: - Init

    public init(
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

public struct VoteSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    public let suggestionId: String
    public let deviceId: String
    public let voteType: VoteType
    public let platform: String
    public let language: String

    // MARK: - Init

    public init(
        suggestionId: String,
        deviceId: String,
        voteType: VoteType,
        platform: String,
        language: String
    ) {
        self.suggestionId = suggestionId
        self.deviceId = deviceId
        self.voteType = voteType
        self.platform = platform
        self.language = language
    }
}

// MARK: - Comment Requests

public struct CreateCommentRequest: Codable, Sendable {
    // MARK: - Properties

    public let suggestionId: String
    public let content: String
    public let deviceId: String
    public let nickname: String?
    public let platform: String
    public let language: String

    // MARK: - Init

    public init(
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

public struct FetchCommentsRequest: Codable, Sendable {
    // MARK: - Properties

    public let suggestionId: String
    public let deviceId: String
    public let limit: Int?
    public let offset: Int?
    public let platform: String
    public let language: String

    // MARK: - Init

    public init(
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

public enum VoteType: String, Codable, Sendable, CaseIterable {
    case upvote
    case downvote
    case remove
}
