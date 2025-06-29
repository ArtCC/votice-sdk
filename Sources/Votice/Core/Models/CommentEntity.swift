//
//  CommentEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CommentEntity: Codable, Sendable, Identifiable {
    let id: String
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
        return nickname ?? "Anonymous"
    }
    var isFromSDK: Bool {
        return deviceId != nil
    }
    var isFromDashboard: Bool {
        return deviceId == nil
    }
}
