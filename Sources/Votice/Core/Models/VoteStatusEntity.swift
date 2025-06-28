//
//  VoteStatusEntity.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteStatusEntity: Codable, Sendable {
    // MARK: - Properties

    let voted: Bool
    let voteType: String?

    // MARK: - Init

    init(voted: Bool, voteType: String? = nil) {
        self.voted = voted
        self.voteType = voteType
    }
}
