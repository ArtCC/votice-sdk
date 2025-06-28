//
//  Vote.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct VoteEntity: Codable, Sendable {
    // MARK: - Properties

    public let suggestionId: String
    public let userId: String?             // Dashboard only
    public let deviceId: String?           // SDK only
    public let createdAt: Date

    // MARK: - Init

    public init(
        suggestionId: String,
        userId: String? = nil,
        deviceId: String? = nil,
        createdAt: Date
    ) {
        self.suggestionId = suggestionId
        self.userId = userId
        self.deviceId = deviceId
        self.createdAt = createdAt
    }
}

// MARK: - Vote Status

public struct VoteStatusEntity: Codable, Sendable {
    // MARK: - Properties

    public let hasVoted: Bool
    public let voteCount: Int

    // MARK: - Init

    public init(hasVoted: Bool, voteCount: Int) {
        self.hasVoted = hasVoted
        self.voteCount = voteCount
    }
}

// MARK: - Extensions

public extension VoteEntity {
    /// Returns whether this vote was created from the SDK
    var isFromSDK: Bool {
        return deviceId != nil
    }

    /// Returns whether this vote was created from the Dashboard
    var isFromDashboard: Bool {
        return userId != nil
    }
}
