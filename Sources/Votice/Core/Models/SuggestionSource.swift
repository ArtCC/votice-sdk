//
//  SuggestionSource.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum SuggestionSource: String, Codable, Sendable, CaseIterable {
    case dashboard
    case sdk
}
