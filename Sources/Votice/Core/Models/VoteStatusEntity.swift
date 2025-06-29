//
//  VoteStatusEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteStatusEntity: Codable, Hashable, Sendable {
    let hasVoted: Bool
    let voteCount: Int
    let suggestionId: String
    let deviceId: String
}
