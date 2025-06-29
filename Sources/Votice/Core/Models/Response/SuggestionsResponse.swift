//
//  SuggestionsResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct SuggestionsResponse: Codable, Sendable {
    let suggestions: [SuggestionEntity]
    let count: Int
    let nextPageToken: NextPageResponse?
}
