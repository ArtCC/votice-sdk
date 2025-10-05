//
//  CommentEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct CommentEntity: Codable, Sendable, Identifiable {
    public let id: String
    public let suggestionId: String
    public let appId: String
    public let text: String
    public let createdAt: String?
    public let updatedAt: String?
    public let createdBy: String?
    public let deviceId: String?
    public let nickname: String?
    public let source: String?
}

extension CommentEntity {
    public var displayName: String {
        return nickname ?? TextManager.shared.texts.anonymous
    }
    public var isFromSDK: Bool {
        return deviceId != nil
    }
    public var isFromDashboard: Bool {
        return deviceId == nil
    }
}
