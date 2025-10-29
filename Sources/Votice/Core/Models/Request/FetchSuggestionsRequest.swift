//
//  FetchSuggestionsRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct FetchSuggestionsRequest: Codable, Sendable {
    // MARK: - Properties

    let appId: String
    let status: SuggestionStatusEntity?
    let excludeCompleted: Bool
    let pagination: PaginationRequest

    // MARK: - Init

    init(appId: String,
         status: SuggestionStatusEntity? = nil,
         excludeCompleted: Bool = false,
         pagination: PaginationRequest) {
        self.appId = appId
        self.status = status
        self.excludeCompleted = excludeCompleted
        self.pagination = pagination
    }
}
