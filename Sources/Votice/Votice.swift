//
//  Votice.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct Votice {
    // MARK: - Configuration

    /// Configure the Votice SDK with your app's API credentials
    /// - Parameters:
    ///   - apiKey: Your app's API key from Votice Dashboard
    ///   - apiSecret: Your app's API secret from Votice Dashboard
    /// - Throws: ConfigurationError if credentials are invalid or already configured
    public static func configure(apiKey: String, apiSecret: String) throws {
        try ConfigurationManager.shared.configure(apiKey: apiKey, apiSecret: apiSecret)
        LogManager.debug = true // Enable debug logging for development
    }

    /// Reset the SDK configuration (useful for testing)
    public static func reset() {
        ConfigurationManager.shared.reset()
    }

    /// Check if the SDK is properly configured
    public static var isConfigured: Bool {
        return ConfigurationManager.shared.isConfigured
    }

    // MARK: - Legacy (deprecated)

    @available(*, deprecated, message: "Use configure(apiKey:apiSecret:) instead")
    public static func initialize() {
        debugPrint("👋 Hello, World!")
    }
}
