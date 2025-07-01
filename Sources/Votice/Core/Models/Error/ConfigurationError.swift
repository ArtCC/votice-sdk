//
//  ConfigurationError.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum ConfigurationError: Error, LocalizedError, Sendable {
    // MARK: - Cases

    case alreadyConfigured
    case notConfigured
    case invalidAPIKey
    case invalidAPISecret
    case invalidAppId

    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .alreadyConfigured:
            return "Votice SDK is already configured"
        case .notConfigured:
            return "Votice SDK is not configured. Call Votice.configure() first"
        case .invalidAPIKey:
            return "Invalid API key provided"
        case .invalidAPISecret:
            return "Invalid API secret provided"
        case .invalidAppId:
            return "Invalid App ID provided"
        }
    }
}
