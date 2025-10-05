//
//  SuggestionStatusEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public enum SuggestionStatusEntity: String, CaseIterable, Codable, Sendable {
    case accepted
    case blocked
    case completed
    case inProgress = "in-progress"
    case pending
    case rejected
}
