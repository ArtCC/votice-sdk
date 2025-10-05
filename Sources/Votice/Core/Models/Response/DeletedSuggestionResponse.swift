//
//  DeletedSuggestionResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct DeletedSuggestionResponse: Codable, Sendable {
    public let suggestion: Int
    public let votes: Int
    public let comments: Int
}
