//
//  CreateSuggestionRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct CreateSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    let title: String
    let description: String?
    let deviceId: String
    let nickname: String?
    let platform: String
    let language: String
    let userIsPremium: Bool

    // MARK: - Init

    init(title: String,
         description: String? = nil,
         deviceId: String,
         nickname: String? = nil,
         platform: String,
         language: String,
         userIsPremium: Bool) {
        self.title = title
        self.description = description
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
        self.userIsPremium = userIsPremium
    }
}
