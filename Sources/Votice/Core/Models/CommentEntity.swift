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
    let createdAt: String?
    let updatedAt: String?
    let createdBy: String?
    let deviceId: String?
    let nickname: String?
    let source: String?
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
