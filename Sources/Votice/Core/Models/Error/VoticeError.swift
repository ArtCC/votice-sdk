//
//  VoticeError.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum VoticeError: Error, LocalizedError, Sendable {
    // MARK: - Cases

    case invalidInput(String)
    case networkError(Error)
    case configurationError(ConfigurationError)
    case unknownError(String)

    // MARK: - Properties

    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return "Invalid input: \(message)"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .configurationError(let configError):
            return configError.errorDescription
        case .unknownError(let message):
            return "Unknown error: \(message)"
        }
    }
}
