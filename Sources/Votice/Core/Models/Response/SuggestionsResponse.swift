//
//  SuggestionsResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct SuggestionsResponse: Codable, Sendable {
    public let suggestions: [SuggestionEntity]
    public let count: Int
    public let nextPageToken: NextPageResponse?
}
