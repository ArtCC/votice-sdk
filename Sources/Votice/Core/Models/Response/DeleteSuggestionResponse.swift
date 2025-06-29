//
//  DeleteSuggestionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct DeleteSuggestionResponse: Codable, Sendable {
    let message: String
    let deleted: DeletedSuggestionResponse
}
