//
//  ConfigurationManagerProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol ConfigurationManagerProtocol: Sendable {
    // MARK: - Properties

    var isConfigured: Bool { get }
    var baseURL: String { get }
    var apiKey: String { get }
    var apiSecret: String { get }

    // MARK: - Public functions

    func configure(apiKey: String, apiSecret: String) throws
    func reset()
    func validateConfiguration() throws
}
