//
//  ConfigurationManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Foundation

protocol ConfigurationManagerProtocol: Sendable {
    var isConfigured: Bool { get }
    var baseURL: String { get }
    var apiKey: String { get }
    var apiSecret: String { get }

    func configure(baseURL: String, apiKey: String, apiSecret: String) throws
    func reset()
}

enum ConfigurationError: Error, Sendable, Equatable {
    case invalidBaseURL
    case invalidAPIKey
    case invalidAPISecret
    case notConfigured
    case alreadyConfigured
}
