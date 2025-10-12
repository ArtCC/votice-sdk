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
    let pagination: PaginationRequest

    // MARK: - Init

    init(appId: String, status: SuggestionStatusEntity? = nil, pagination: PaginationRequest) {
        self.appId = appId
        self.status = status
        self.pagination = pagination
    }
}
