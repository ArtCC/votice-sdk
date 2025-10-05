//
//  VoteStatusEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct VoteStatusEntity: Codable, Hashable, Sendable {
    public let hasVoted: Bool
    public let voteCount: Int
    public let suggestionId: String
    public let deviceId: String
}
