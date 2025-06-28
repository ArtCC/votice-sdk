//
//  CreateCommentRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CreateCommentRequest: Codable, Sendable {
    // MARK: - Properties

    let suggestionId: String
    let content: String
    let deviceId: String
    let nickname: String?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        suggestionId: String,
        content: String,
        deviceId: String,
        nickname: String? = nil,
        platform: String,
        language: String
    ) {
        self.suggestionId = suggestionId
        self.content = content
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
    }
}
