//
//  DeletedSuggestionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct DeletedSuggestionResponse: Codable, Sendable {
    let suggestion: Int
    let votes: Int
    let comments: Int
}
