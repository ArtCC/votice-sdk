//
//  VoteStatusRequest.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct VoteStatusRequest: Codable, Sendable {
    let suggestionId: String
    let deviceId: String
}
