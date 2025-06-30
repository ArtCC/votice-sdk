//
//  Votice.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import SwiftUI

// swiftlint:disable line_length
#if os(macOS) || os(tvOS)
#warning("Votice SDK is currently only supported on iOS and iPadOS. Support for macOS and tvOS will be available in future releases.")
#endif
// swiftlint:enable line_length

public struct Votice {
    // MARK: - Configuration

    /// Configure the Votice SDK with your app's API credentials
    /// - Parameters:
    ///   - apiKey: Your app's API key from Votice Dashboard
    ///   - apiSecret: Your app's API secret from Votice Dashboard
    ///   - appId: Your app's unique identifier (optional, defaults to "default")
    /// - Throws: ConfigurationError if credentials are invalid or already configured
    public static func configure(apiKey: String, apiSecret: String, appId: String) throws {
        try ConfigurationManager.shared.configure(apiKey: apiKey, apiSecret: apiSecret, appId: appId)

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

    // MARK: - UI Presentation

    /// Present the Votice feedback interface
    /// - Parameters:
    ///   - theme: Custom theme for the UI (optional)
    /// - Returns: A SwiftUI View that can be presented modally or embedded
    public static func feedbackView(theme: VoticeTheme? = nil) -> some View {
        SuggestionListView()
            .voticeTheme(theme ?? .default)
    }

    /// Present the Votice feedback interface as a sheet/modal
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation
    ///   - theme: Custom theme for the UI (optional)
    public static func feedbackSheet(isPresented: Binding<Bool>, theme: VoticeTheme? = nil) -> some View {
        EmptyView()
            .sheet(isPresented: isPresented) {
                SuggestionListView()
                    .voticeTheme(theme ?? .default)
            }
    }

    // MARK: - Theme Configuration

    /// Create a custom theme for the Votice UI
    /// - Parameters:
    ///   - primaryColor: Primary color for buttons and accents
    ///   - backgroundColor: Background color for the interface
    ///   - surfaceColor: Surface color for cards and components
    public static func createTheme(
        primaryColor: Color? = nil,
        backgroundColor: Color? = nil,
        surfaceColor: Color? = nil
    ) -> VoticeTheme {
        var colors = VoticeColors.default

        if let primaryColor = primaryColor {
            colors = VoticeColors(
                primary: primaryColor,
                secondary: colors.secondary,
                accent: colors.accent,
                background: backgroundColor ?? colors.background,
                surface: surfaceColor ?? colors.surface,
                onSurface: colors.onSurface,
                onBackground: colors.onBackground,
                success: colors.success,
                warning: colors.warning,
                error: colors.error,
                upvote: colors.upvote,
                downvote: colors.downvote,
                pending: colors.pending,
                accepted: colors.accepted,
                inProgress: colors.inProgress,
                completed: colors.completed,
                rejected: colors.rejected
            )
        }

        return VoticeTheme(colors: colors, typography: .default, spacing: .default, cornerRadius: .default)
    }

    // MARK: - Legacy (deprecated)

    @available(*, deprecated, message: "Use configure(apiKey:apiSecret:) instead")
    public static func initialize() {
        debugPrint("👋 Hello, World!")
    }
}
