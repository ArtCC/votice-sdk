//
//  VoteSuggestionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct VoteSuggestionResponse: Codable, Sendable {
    public let message: String
    public let vote: VoteEntity?
    public let suggestion: SuggestionEntity?
}
