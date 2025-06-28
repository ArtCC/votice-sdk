//
//  SuggestionEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct SuggestionEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    let id: String
    let appId: String?
    let title: String?
    let text: String?
    let description: String?
    let nickname: String?
    let createdAt: String?
    let updatedAt: String?
    let platform: String?
    let createdBy: String?
    let status: SuggestionStatusEntity
    let source: SuggestionSource
    let commentCount: Int
    let voteCount: Int
    let language: String?

    // MARK: - Init

    init(
        id: String,
        appId: String? = nil,
        title: String? = nil,
        text: String? = nil,
        description: String? = nil,
        nickname: String? = nil,
        createdAt: String? = nil,
        updatedAt: String? = nil,
        platform: String? = nil,
        createdBy: String? = nil,
        status: SuggestionStatusEntity,
        source: SuggestionSource,
        commentCount: Int = 0,
        voteCount: Int = 0,
        language: String? = nil
    ) {
        self.id = id
        self.appId = appId
        self.title = title
        self.text = text
        self.description = description
        self.nickname = nickname
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.platform = platform
        self.createdBy = createdBy
        self.status = status
        self.source = source
        self.commentCount = commentCount
        self.voteCount = voteCount
        self.language = language
    }
}

// MARK: - Extensions

extension SuggestionEntity {
    /// Returns the display text for the suggestion
    var displayText: String {
        return text ?? title ?? ""
    }

    /// Returns whether this suggestion was created from the SDK
    var isFromSDK: Bool {
        return source == .sdk
    }

    /// Returns whether this suggestion was created from the Dashboard
    var isFromDashboard: Bool {
        return source == .dashboard
    }

    /// Returns whether the suggestion can be voted on
    var canBeVoted: Bool {
        return status == .pending || status == .accepted || status == .inProgress
    }
}
