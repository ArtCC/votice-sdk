//
//  ErrorResponse.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct ErrorResponse: Codable, Sendable {
    public let error: String
    public let message: String
}
