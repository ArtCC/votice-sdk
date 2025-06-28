//
//  NetworkManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol NetworkManagerProtocol: Sendable {
    func request<T: Codable & Sendable>(endpoint: NetworkEndpoint, responseType: T.Type) async throws -> T
    func request(endpoint: NetworkEndpoint) async throws
}
