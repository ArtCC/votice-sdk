//
//  NetworkError.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

enum NetworkError: Error, Sendable, Equatable {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError(String)
    case serverError(Int, String)
    case authenticationError
    case unknownError(String)
}
