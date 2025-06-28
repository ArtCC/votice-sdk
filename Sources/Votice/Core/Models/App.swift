//
//  App.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Foundation

public struct App: Codable, Sendable, Identifiable {
    // MARK: - Properties

    public let id: String
    public let name: String
    public let platform: String
    public let description: String?
    public let apiKey: String
    public let apiSecret: String
    public let ownerId: String
    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Initialization

    public init(
        id: String,
        name: String,
        platform: String,
        description: String? = nil,
        apiKey: String,
        apiSecret: String,
        ownerId: String,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.name = name
        self.platform = platform
        self.description = description
        self.apiKey = apiKey
        self.apiSecret = apiSecret
        self.ownerId = ownerId
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - App Details

public struct AppDetails: Codable, Sendable {
    // MARK: - Properties

    public let app: App
    public let suggestionCount: Int
    public let pendingSuggestionCount: Int
    public let commentCount: Int
    public let voteCount: Int

    // MARK: - Initialization

    public init(
        app: App,
        suggestionCount: Int,
        pendingSuggestionCount: Int,
        commentCount: Int,
        voteCount: Int
    ) {
        self.app = app
        self.suggestionCount = suggestionCount
        self.pendingSuggestionCount = pendingSuggestionCount
        self.commentCount = commentCount
        self.voteCount = voteCount
    }
}

// MARK: - Extensions

public extension App {
    /// Returns whether the app has a description
    var hasDescription: Bool {
        return description != nil && !description!.isEmpty
    }
}
