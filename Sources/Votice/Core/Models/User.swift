//
//  User.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct UserEntity: Codable, Sendable, Identifiable {
    // MARK: - Properties

    let id: String
    let email: String
    let name: String
    let plan: UserPlan
    let appCount: Int
    let language: String
    let fcmToken: String?
    let createdAt: Date
    let updatedAt: Date

    // MARK: - Init

    init(
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

enum UserPlan: String, Codable, CaseIterable, Sendable {
    case free
    case pro
    case enterprise
}

// MARK: - Extensions

extension UserEntity {
    /// Returns whether the user has push notifications enabled
    var hasPushNotifications: Bool {
        return fcmToken != nil && !fcmToken!.isEmpty
    }

    /// Returns whether the user is on a paid plan
    var isPaidPlan: Bool {
        return plan != .free
    }
}
