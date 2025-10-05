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

extension CommentEntity {
    var displayName: String {
        return nickname ?? TextManager.shared.texts.anonymous
    }
    var isFromSDK: Bool {
        return deviceId != nil
    }
    var isFromDashboard: Bool {
        return deviceId == nil
    }
}
