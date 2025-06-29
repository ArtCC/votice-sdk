//
//  SuggestionStatusEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum SuggestionStatusEntity: String, Codable, Sendable, CaseIterable {
    case pending
    case accepted
    case inProgress = "in-progress"
    case completed
    case rejected
}
