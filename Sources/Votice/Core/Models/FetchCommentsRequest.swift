//
//  FetchCommentsRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct FetchCommentsRequest: Codable, Sendable {
    // MARK: - Properties

    let suggestionId: String
    let deviceId: String
    let limit: Int?
    let offset: Int?
    let platform: String
    let language: String

    // MARK: - Init

    init(
        suggestionId: String,
        deviceId: String,
        limit: Int? = nil,
        offset: Int? = nil,
        platform: String,
        language: String
    ) {
        self.suggestionId = suggestionId
        self.deviceId = deviceId
        self.limit = limit
        self.offset = offset
        self.platform = platform
        self.language = language
    }
}
