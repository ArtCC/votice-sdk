//
//  NextPageResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct NextPageResponse: Codable, Sendable {
    public let voteCount: Int
    public let createdAt: String
}
