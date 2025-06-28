//
//  Suggestion.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct SuggestionEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    public let id: String
    public let appId: String
    public let title: String?              // Dashboard only
    public let text: String?               // SDK only
    public let description: String?        // Dashboard only
    public let status: SuggestionStatus
    public let voteCount: Int
    public let commentCount: Int
    public let source: SuggestionSource
    public let createdBy: String           // userId for dashboard, deviceId for SDK
    public let deviceId: String?           // SDK only
    public let nickname: String?           // SDK only
    public let platform: String?          // SDK only
    public let language: String?           // SDK only
    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Initialization

    public init(
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

public enum SuggestionStatus: String, Codable, Sendable, CaseIterable {
    case pending = "pending"
    case accepted = "accepted"
    case inProgress = "in-progress"
    case completed = "completed"
    case rejected = "rejected"
}

// MARK: - Suggestion Source

public enum SuggestionSource: String, Codable, Sendable, CaseIterable {
    case dashboard
    case sdk
}

// MARK: - Extensions

public extension SuggestionEntity {
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
