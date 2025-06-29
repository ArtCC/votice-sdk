//
//  FetchCommentsRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct FetchCommentsRequest: Codable, Sendable {
    let suggestionId: String
    let pagination: PaginationRequest
}
