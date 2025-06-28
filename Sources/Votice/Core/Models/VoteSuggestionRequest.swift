//
//  VoteSuggestionRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteSuggestionRequest: Codable, Sendable {
    let suggestionId: String
    let deviceId: String
    let voteType: VoteType
    let platform: String
    let language: String
}
