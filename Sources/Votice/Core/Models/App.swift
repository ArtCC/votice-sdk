//
//  App.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct AppEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    let id: String
    let name: String
    let platform: String
    let description: String?
    let apiKey: String
    let apiSecret: String
    let ownerId: String
    let createdAt: Date
    let updatedAt: Date

    // MARK: - Init

    init(
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

struct AppDetailsEntity: Codable, Sendable {
    // MARK: - Properties

    let app: AppEntity
    let suggestionCount: Int
    let pendingSuggestionCount: Int
    let commentCount: Int
    let voteCount: Int
}

// MARK: - Extensions

extension AppEntity {
    /// Returns whether the app has a description
    var hasDescription: Bool {
        return description != nil && !description!.isEmpty
    }
}
