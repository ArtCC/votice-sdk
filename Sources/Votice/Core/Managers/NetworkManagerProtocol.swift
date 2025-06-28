//
//  NetworkManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol: Sendable {
    func request<T: Codable & Sendable>(
        endpoint: NetworkEndpoint,
        responseType: T.Type
    ) async throws -> T
    func request(endpoint: NetworkEndpoint) async throws
}

struct NetworkEndpoint: Sendable {
    let path: String
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]

    init(path: String, method: HTTPMethod, body: Data? = nil, headers: [String: String] = [:]) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }
}

enum HTTPMethod: String, Sendable {
    case GET
    case POST
    case PUT
    case DELETE
}

enum NetworkError: Error, Sendable, Equatable {
    case invalidURL
    case noData
    case invalidResponse
    case decodingError(String)
    case serverError(Int, String)
    case authenticationError
    case unknownError(String)
}
