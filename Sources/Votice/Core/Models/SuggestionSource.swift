//
//  SuggestionSource.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum SuggestionSource: String, CaseIterable, Codable, Sendable {
    case dashboard
    case sdk
}
