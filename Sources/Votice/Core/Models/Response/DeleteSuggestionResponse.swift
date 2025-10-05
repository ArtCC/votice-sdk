//
//  DeleteSuggestionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct DeleteSuggestionResponse: Codable, Sendable {
    public let message: String
    public let deleted: DeletedSuggestionResponse
}
