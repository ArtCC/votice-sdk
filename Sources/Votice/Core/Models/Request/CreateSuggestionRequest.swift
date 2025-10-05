//
//  CreateSuggestionRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct CreateSuggestionRequest: Codable, Sendable {
    // MARK: - Properties

    let title: String
    let description: String?
    let deviceId: String?
    let nickname: String?
    let platform: String?
    let language: String?
    let userIsPremium: Bool
    let issue: Bool
    let urlImage: String?

    // MARK: - Init

    init(title: String,
         description: String? = nil,
         deviceId: String? = nil,
         nickname: String? = nil,
         platform: String? = nil,
         language: String? = nil,
         userIsPremium: Bool,
         issue: Bool,
         urlImage: String? = nil) {
        self.title = title
        self.description = description
        self.deviceId = deviceId
        self.nickname = nickname
        self.platform = platform
        self.language = language
        self.userIsPremium = userIsPremium
        self.issue = issue
        self.urlImage = urlImage
    }
}
