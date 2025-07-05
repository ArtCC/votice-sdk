//
//  VoticeFontConfiguration.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

public struct VoticeFontConfiguration: Sendable {
    // MARK: - Properties

    public let fontFamily: String?
    public let weights: [FontWeight: String]

    public static let system = VoticeFontConfiguration(fontFamily: nil, weights: [:])

    // MARK: - Init

    public init(fontFamily: String? = nil, weights: [FontWeight: String] = [:]) {
        self.fontFamily = fontFamily
        self.weights = weights
    }

    // MARK: - Public

    /// Get the font name for a specific weight, with fallback to regular
    public func fontName(for weight: FontWeight) -> String? {
        guard let fontFamily else {
            return nil
        }

        // Try to get specific weight
        if let specificWeight = weights[weight] {
            return specificWeight
        }

        // Fallback to regular weight
        if let regularWeight = weights[.regular] {
            return regularWeight
        }

        // Final fallback to font family name
        return fontFamily
    }

    /// Check if custom fonts are configured
    public var hasCustomFonts: Bool {
        return fontFamily != nil && !weights.isEmpty
    }
}
