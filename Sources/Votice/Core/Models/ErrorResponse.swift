//
//  ErrorResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, Sendable {
    let error: String
    let message: String
}
