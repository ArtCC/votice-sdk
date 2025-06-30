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
        return createAdvancedTheme(
            primaryColor: primaryColor,
            backgroundColor: backgroundColor,
            surfaceColor: surfaceColor
        )
    }

    /// Create a custom theme with advanced color configuration
    /// - Parameters:
    ///   - primaryColor: Primary color for buttons and main accents
    ///   - secondaryColor: Secondary color for less prominent elements
    ///   - accentColor: Accent color for highlights and secondary actions
    ///   - backgroundColor: Background color for the interface
    ///   - surfaceColor: Surface color for cards and components
    ///   - destructiveColor: Color for destructive actions (delete buttons)
    ///   - successColor: Color for success states and confirmations
    ///   - warningColor: Color for warnings and pending states
    ///   - errorColor: Color for errors and failed states
    ///   - pendingColor: Color for pending suggestion status
    ///   - acceptedColor: Color for accepted suggestion status
    ///   - inProgressColor: Color for in-progress suggestion status
    ///   - completedColor: Color for completed suggestion status
    ///   - rejectedColor: Color for rejected suggestion status
    public static func createAdvancedTheme(
        primaryColor: Color? = nil,
        secondaryColor: Color? = nil,
        accentColor: Color? = nil,
        backgroundColor: Color? = nil,
        surfaceColor: Color? = nil,
        destructiveColor: Color? = nil,
        successColor: Color? = nil,
        warningColor: Color? = nil,
        errorColor: Color? = nil,
        pendingColor: Color? = nil,
        acceptedColor: Color? = nil,
        inProgressColor: Color? = nil,
        completedColor: Color? = nil,
        rejectedColor: Color? = nil
    ) -> VoticeTheme {
        let defaultColors = VoticeColors.default

        // Use provided colors or fall back to smart defaults
        let finalPrimary = primaryColor ?? defaultColors.primary
        let finalSecondary = secondaryColor ?? defaultColors.secondary
        let finalAccent = accentColor ?? defaultColors.accent
        let finalBackground = backgroundColor ?? defaultColors.background
        let finalSurface = surfaceColor ?? defaultColors.surface
        let finalDestructive = destructiveColor ?? errorColor ?? defaultColors.error
        let finalSuccess = successColor ?? defaultColors.success
        let finalWarning = warningColor ?? defaultColors.warning
        let finalError = errorColor ?? destructiveColor ?? defaultColors.error

        // Smart defaults for status colors based on main colors
        let finalPending = pendingColor ?? finalWarning
        let finalAccepted = acceptedColor ?? finalPrimary
        let finalInProgress = inProgressColor ?? defaultColors.inProgress
        let finalCompleted = completedColor ?? finalSuccess
        let finalRejected = rejectedColor ?? finalDestructive

        // Create the custom theme with the finalized colors
        let customColors = VoticeColors(
            primary: finalPrimary,
            secondary: finalSecondary,
            accent: finalAccent,
            background: finalBackground,
            surface: finalSurface,
            onSurface: defaultColors.onSurface,
            onBackground: defaultColors.onBackground,
            success: finalSuccess,
            warning: finalWarning,
            error: finalError,
            upvote: finalSuccess,
            downvote: finalDestructive,
            pending: finalPending,
            accepted: finalAccepted,
            inProgress: finalInProgress,
            completed: finalCompleted,
            rejected: finalRejected
        )

        // Return the complete theme with default typography, spacing, and corner radius
        return VoticeTheme(
            colors: customColors,
            typography: .default,
            spacing: .default,
            cornerRadius: .default
        )
    }

    // MARK: - Text Customization

    public static func setTexts(_ texts: VoticeTextsProtocol) {
        TextManager.shared.setTexts(texts)
    }

    /// Reset texts to the default English implementation
    public static func resetTextsToDefault() {
        TextManager.shared.resetToDefault()
    }

    // MARK: - Legacy (deprecated)

    @available(*, deprecated, message: "Use configure(apiKey:apiSecret:appId:) instead")
    public static func initialize() {
        debugPrint("👋 Hello, World!")
    }
}
