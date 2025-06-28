//
//  Requests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Foundation

// MARK: - Suggestion Requests

public struct CreateSuggestionRequest: Codable, Sendable {
    public let deviceId: String
    public let text: String
    public let nickname: String
    public let platform: String
    public let language: String

    public init(
        deviceId: String,
        text: String,
        nickname: String,
        platform: String,
        language: String
    ) {
        self.deviceId = deviceId
        self.text = text
        self.nickname = nickname
        self.platform = platform
        self.language = language
    }
}

// MARK: - Comment Requests

public struct CreateCommentRequest: Codable, Sendable {
    public let deviceId: String
    public let text: String
    public let nickname: String

    public init(
        deviceId: String,
        text: String,
        nickname: String
    ) {
        self.deviceId = deviceId
        self.text = text
        self.nickname = nickname
    }
}

// MARK: - Vote Requests

public struct VoteRequest: Codable, Sendable {
    public let deviceId: String

    public init(deviceId: String) {
        self.deviceId = deviceId
    }
}
