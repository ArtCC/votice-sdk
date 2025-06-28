//
//  Vote.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteEntity: Codable, Sendable {
    // MARK: - Properties

    let id: String
    let suggestionId: String
    let appId: String
    let voteType: String            // "upvote" or "downvote"
    let createdBy: String           // userId for dashboard, deviceId for SDK
    let deviceId: String?           // SDK only
    let createdAt: Date

    // MARK: - Init

    init(
        id: String,
        suggestionId: String,
        appId: String,
        voteType: String,
        createdBy: String,
        deviceId: String? = nil,
        createdAt: Date
    ) {
        self.id = id
        self.suggestionId = suggestionId
        self.appId = appId
        self.voteType = voteType
        self.createdBy = createdBy
        self.deviceId = deviceId
        self.createdAt = createdAt
    }
}

// MARK: - Vote Status Entity

struct VoteStatusEntity: Codable, Sendable {
    // MARK: - Properties

    let voted: Bool
    let voteType: String?           // "upvote", "downvote", or nil

    // MARK: - Init

    init(voted: Bool, voteType: String? = nil) {
        self.voted = voted
        self.voteType = voteType
    }
}

// MARK: - Extensions

extension VoteEntity {
    /// Returns whether this vote was created from the SDK
    var isFromSDK: Bool {
        return deviceId != nil
    }

    /// Returns whether this vote was created from the Dashboard
    var isFromDashboard: Bool {
        return deviceId == nil
    }
}
