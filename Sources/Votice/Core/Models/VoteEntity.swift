//
//  VoteEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteEntity: Codable, Sendable {
    let suggestionId: String?
    let appId: String?
    let deviceId: String?
    let source: SuggestionSource?
    let createdAt: String?
}
