//
//  VoteType.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum VoteType: String, CaseIterable, Codable, Sendable {
    case upvote
    case downvote
}
