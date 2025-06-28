//
//  CommentEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CommentEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    let id: String
    let suggestionId: String
    let appId: String
    let text: String
    let nickname: String? // SDK only
    let createdBy: String // userId for dashboard, deviceId for SDK
    let deviceId: String? // SDK only
    let createdAt: Date

    // MARK: - Init

    init(
        id: String,
        suggestionId: String,
        appId: String,
        text: String,
        nickname: String? = nil,
        createdBy: String,
        deviceId: String? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.suggestionId = suggestionId
        self.appId = appId
        self.text = text
        self.nickname = nickname
        self.createdBy = createdBy
        self.deviceId = deviceId
        self.createdAt = createdAt
    }
}

// MARK: - Extensions

extension CommentEntity {
    /// Returns the display name for the comment author
    var displayName: String {
        return nickname ?? "Anonymous"
    }

    /// Returns whether this comment was created from the SDK
    var isFromSDK: Bool {
        return deviceId != nil
    }

    /// Returns whether this comment was created from the Dashboard
    var isFromDashboard: Bool {
        return deviceId == nil
    }
}
