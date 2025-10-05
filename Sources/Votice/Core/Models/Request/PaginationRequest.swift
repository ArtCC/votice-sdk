//
//  PaginationRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct PaginationRequest: Codable, Sendable {
    // MARK: - Properties

    public let startAfter: StartAfterRequest?
    public let pageLimit: Int?

    // MARK: - Init

    public init(startAfter: StartAfterRequest? = nil, pageLimit: Int? = nil) {
        self.startAfter = startAfter
        self.pageLimit = pageLimit
    }
}
