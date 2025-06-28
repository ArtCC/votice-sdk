//
//  Comment.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Foundation

public struct Comment: Codable, Sendable, Identifiable {
    // MARK: - Properties

    public let id: String
    public let suggestionId: String
    public let appId: String
    public let text: String
    public let nickname: String?           // SDK only
    public let createdBy: String           // userId for dashboard, deviceId for SDK
    public let deviceId: String?           // SDK only
    public let createdAt: Date

    // MARK: - Initialization

    public init(
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

public extension Comment {
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
