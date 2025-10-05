//
//  VoteEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct VoteEntity: Codable, Sendable {
    public let suggestionId: String?
    public let appId: String?
    public let deviceId: String?
    public let source: SuggestionSource?
    public let createdAt: String?
}
