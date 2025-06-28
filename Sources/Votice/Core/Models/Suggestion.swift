//
//  Suggestion.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct SuggestionEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    let id: String
    let appId: String
    let title: String?              // Dashboard only
    let text: String?               // SDK only
    let description: String?        // Dashboard only
    let status: SuggestionStatus
    let voteCount: Int
    let commentCount: Int
    let source: SuggestionSource
    let createdBy: String           // userId for dashboard, deviceId for SDK
    let deviceId: String?           // SDK only
    let nickname: String?           // SDK only
    let platform: String?          // SDK only
    let language: String?           // SDK only
    let createdAt: Date
    let updatedAt: Date

    // MARK: - Init

    init(
        id: String,
        appId: String,
        title: String? = nil,
        text: String? = nil,
        description: String? = nil,
        status: SuggestionStatus,
        voteCount: Int,
        commentCount: Int,
        source: SuggestionSource,
        createdBy: String,
        deviceId: String? = nil,
        nickname: String? = nil,
        platform: String? = nil,
        language: String? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.appId = appId
        self.title = title
        self.text = text
        self.description = description
        self.status = status
        self.voteCount = voteCount
        self.commentCount = commentCount
        self.source = source
        self.createdBy = createdBy
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Suggestion Status

enum SuggestionStatus: String, Codable, Sendable, CaseIterable {
    case pending = "pending"
    case accepted = "accepted"
    case inProgress = "in-progress"
    case completed = "completed"
    case rejected = "rejected"
}

// MARK: - Suggestion Source

enum SuggestionSource: String, Codable, Sendable, CaseIterable {
    case dashboard
    case sdk
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
