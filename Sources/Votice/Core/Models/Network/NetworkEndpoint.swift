//
//  NetworkEndpoint.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

struct NetworkEndpoint: Sendable {
    // MARK: - Properties

    let path: String
    let method: HTTPMethod
    let body: Data?
    let headers: [String: String]

    // MARK: - Init

    init(path: String, method: HTTPMethod, body: Data? = nil, headers: [String: String] = [:]) {
        self.path = path
        self.method = method
        self.body = body
        self.headers = headers
    }
}
