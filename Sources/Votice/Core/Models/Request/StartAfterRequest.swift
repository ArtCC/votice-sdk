//
//  StartAfterRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct StartAfterRequest: Codable, Sendable {
    // MARK: - Properties

    public let voteCount: Int?
    public let createdAt: String

    // MARK: - Init

    public init(voteCount: Int?, createdAt: String) {
        self.voteCount = voteCount
        self.createdAt = createdAt
    }
}
