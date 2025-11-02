//
//  SuggestionEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct SuggestionEntity: Codable, Equatable, Identifiable, Sendable {
    // MARK: - Properties

    public var commentCount: Int?

    public let id: String
    public let appId: String?
    public let title: String?
    public let text: String?
    public let description: String?
    public let nickname: String?
    public let createdAt: String?
    public let updatedAt: String?
    public let platform: String?
    public let createdBy: String?
    public let deviceId: String?
    public let status: SuggestionStatusEntity?
    public let progress: Int?
    public let source: SuggestionSource?
    public let voteCount: Int?
    public let language: String?
    public let userIsPremium: Bool?
    public let issue: Bool?
    public let urlImage: String?

    // MARK: - Init

    public init(
        id: String,
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
        progress: Int? = nil,
        source: SuggestionSource? = nil,
        commentCount: Int? = nil,
        voteCount: Int? = nil,
        language: String? = nil,
        userIsPremium: Bool? = false,
        issue: Bool? = false,
        urlImage: String? = nil
    ) {
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
        self.progress = progress
        self.source = source
        self.commentCount = commentCount
        self.voteCount = voteCount
        self.language = language
        self.userIsPremium = userIsPremium
        self.issue = issue
        self.urlImage = urlImage
    }
}

extension SuggestionEntity {
    // MARK: - Properties

    var displayText: String {
        text ?? title ?? ""
    }
    var isFromSDK: Bool {
        source == .sdk
    }
    var isFromDashboard: Bool {
        source == .dashboard
    }
    var canBeVoted: Bool {
        status == .pending || status == .accepted || status == .inProgress
    }

    // MARK: - Functions

    func copyWith(
        id: String? = nil,
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
        progress: Int? = nil,
        source: SuggestionSource? = nil,
        commentCount: Int? = nil,
        voteCount: Int? = nil,
        language: String? = nil,
        userIsPremium: Bool? = false,
        issue: Bool? = false,
        urlImage: String? = nil
    ) -> SuggestionEntity {
        SuggestionEntity(
            id: id ?? self.id,
            appId: appId ?? self.appId,
            title: title ?? self.title,
            text: text ?? self.text,
            description: description ?? self.description,
            nickname: nickname ?? self.nickname,
            createdAt: createdAt ?? self.createdAt,
            updatedAt: updatedAt ?? self.updatedAt,
            platform: platform ?? self.platform,
            createdBy: createdBy ?? self.createdBy,
            deviceId: deviceId ?? self.deviceId,
            status: status ?? self.status,
            progress: progress ?? self.progress,
            source: source ?? self.source,
            commentCount: commentCount ?? self.commentCount,
            voteCount: voteCount ?? self.voteCount,
            language: language ?? self.language,
            userIsPremium: userIsPremium ?? self.userIsPremium,
            issue: issue ?? self.issue,
            urlImage: urlImage ?? self.urlImage
        )
    }
}
