//
//  User.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct UserEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    public let id: String
    public let email: String
    public let name: String
    public let plan: UserPlan
    public let appCount: Int
    public let language: String
    public let fcmToken: String?
    public let createdAt: Date
    public let updatedAt: Date

    // MARK: - Init

    public init(
        id: String,
        email: String,
        name: String,
        plan: UserPlan,
        appCount: Int,
        language: String,
        fcmToken: String? = nil,
        createdAt: Date,
        updatedAt: Date
    ) {
        self.id = id
        self.email = email
        self.name = name
        self.plan = plan
        self.appCount = appCount
        self.language = language
        self.fcmToken = fcmToken
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - User Plan

public enum UserPlan: String, Codable, Sendable, CaseIterable {
    case free
    case pro
    case enterprise
}

// MARK: - Extensions

public extension UserEntity {
    /// Returns whether the user has push notifications enabled
    var hasPushNotifications: Bool {
        return fcmToken != nil && !fcmToken!.isEmpty
    }

    /// Returns whether the user is on a paid plan
    var isPaidPlan: Bool {
        return plan != .free
    }
}
