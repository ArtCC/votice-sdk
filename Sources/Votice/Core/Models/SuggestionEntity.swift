//
//  SuggestionEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct SuggestionEntity: Codable, Equatable, Identifiable, Sendable {
    // MARK: - Properties

    let id: String
    let appId: String?
    let title: String?
    let text: String?
    let description: String?
    let nickname: String?
    let createdAt: String?
    let updatedAt: String?
    let platform: String?
    let createdBy: String?
    let deviceId: String?
    let status: SuggestionStatusEntity?
    let source: SuggestionSource?
    let commentCount: Int?
    let voteCount: Int?
    let language: String?

    // MARK: - Init

    init(id: String,
         appId: String? = nil,
         title: String? = nil,
         text: String? = nil,
         description: String? = nil,
         nickname: String? = nil,
         createdAt: String? = nil,
         updatedAt: String? = nil,
         platform: String? = nil,
         createdBy: String? = nil,
         deviceId: String? = nil,
         status: SuggestionStatusEntity? = nil,
         source: SuggestionSource? = nil,
         commentCount: Int? = nil,
         voteCount: Int? = nil,
         language: String? = nil) {
        self.id = id
        self.appId = appId
        self.title = title
        self.text = text
        self.description = description
        self.nickname = nickname
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.platform = platform
        self.createdBy = createdBy
        self.deviceId = deviceId
        self.status = status
        self.source = source
        self.commentCount = commentCount
        self.voteCount = voteCount
        self.language = language
    }
}

extension SuggestionEntity {
    var displayText: String {
        return text ?? title ?? ""
    }
    var isFromSDK: Bool {
        return source == .sdk
    }
    var isFromDashboard: Bool {
        return source == .dashboard
    }
    var canBeVoted: Bool {
        return status == .pending || status == .accepted || status == .inProgress
    }
}
