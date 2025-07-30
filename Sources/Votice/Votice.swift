//
//  Votice.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import SwiftUI

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

        // Logs are disabled by default so as not to disturb the developer.
        // They can be enabled explicitly if necessary.
    }

    /// Reset the SDK configuration (useful for testing)
    public static func reset() {
        ConfigurationManager.shared.reset()
    }

    /// Check if the SDK is properly configured
    public static var isConfigured: Bool {
        return ConfigurationManager.shared.isConfigured
    }

    // MARK: - Debugging

    /// Enable or disable debug logging for the Votice SDK
    /// - Parameter enabled: Whether to show debug logs from the SDK
    /// - Note: Logs are disabled by default to avoid cluttering the developer's console
    public static func setDebugLogging(enabled: Bool) {
        LogManager.debug = enabled
    }

    /// Check if debug logging is currently enabled
    public static var isDebugLoggingEnabled: Bool {
        return LogManager.debug
    }

    /// Enable or disable the comment feature in the Votice SDK
    /// - Parameter enabled: Whether to enable comments in the feedback interface
    /// - Note: Comments are enabled by default
    public static func setCommentIsEnabled(enabled: Bool) {
        ConfigurationManager.shared.commentIsEnabled = enabled
    }

    // MARK: - UI Presentation

    /// Present the Votice feedback interface
    /// - Parameters:
    ///   - theme: Custom theme for the UI (optional)
    /// - Returns: A SwiftUI View that can be presented modally or embedded
    public static func feedbackView(theme: VoticeTheme? = nil) -> some View {
        SuggestionListView()
            .voticeTheme(theme ?? .default)
#if os(macOS)
            .frame(minWidth: 800, minHeight: 600)
#endif
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
#if os(macOS)
                    .frame(minWidth: 800, minHeight: 600)
#endif
            }
    }

    // MARK: - Theme Configuration

    /// Create a custom theme for the Votice UI
    /// - Parameters:
    ///   - primaryColor: Primary color for buttons and accents
    ///   - backgroundColor: Background color for the interface
    ///   - surfaceColor: Surface color for cards and components
    public static func createTheme(primaryColor: Color? = nil,
                                   backgroundColor: Color? = nil,
                                   surfaceColor: Color? = nil) -> VoticeTheme {
        // Use smart defaults if no colors are provided
        return createAdvancedTheme(primaryColor: primaryColor,
                                   backgroundColor: backgroundColor,
                                   surfaceColor: surfaceColor)
    }

    /// Get a system theme that automatically adapts to the user's appearance preference
    /// - Returns: A theme that follows system light/dark mode automatically
    public static func systemTheme() -> VoticeTheme {
        let customColors = VoticeColors(
            primary: Color(red: 0.0, green: 0.48, blue: 1.0),        // iOS System Blue
            secondary: Color(red: 0.56, green: 0.56, blue: 0.58),    // iOS System Gray
            accent: Color(red: 1.0, green: 0.58, blue: 0.0),         // iOS System Orange
            background: Color.systemBackground,                      // Adapts automatically
            surface: Color.secondarySystemBackground,                // Adapts automatically
            onSurface: Color.primary,                                // Adapts automatically
            onBackground: Color.primary,                             // Adapts automatically
            success: Color(red: 0.20, green: 0.78, blue: 0.35),      // iOS System Green
            warning: Color(red: 1.0, green: 0.58, blue: 0.0),        // iOS System Orange
            error: Color(red: 1.0, green: 0.23, blue: 0.19),         // iOS System Red
            upvote: Color(red: 0.20, green: 0.78, blue: 0.35),       // Success Green
            downvote: Color(red: 1.0, green: 0.23, blue: 0.19),      // Error Red
            pending: Color(red: 1.0, green: 0.58, blue: 0.0),        // Warning Orange
            accepted: Color(red: 0.0, green: 0.48, blue: 1.0),       // Primary Blue
            inProgress: Color(red: 0.48, green: 0.40, blue: 0.93),   // Purple
            completed: Color(red: 0.20, green: 0.78, blue: 0.35),    // Success Green
            rejected: Color(red: 1.0, green: 0.23, blue: 0.19)       // Error Red
        )

        // Return the complete theme with default typography, spacing, and corner radius
        return VoticeTheme(colors: customColors, typography: .default, spacing: .default, cornerRadius: .default)
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
    public static func createAdvancedTheme(primaryColor: Color? = nil,
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
                                           rejectedColor: Color? = nil) -> VoticeTheme {
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

        // Smart text colors - if using system colors, use dynamic text colors
        // If using custom colors, use appropriate contrasting colors
        let finalOnSurface: Color
        let finalOnBackground: Color

        if backgroundColor == nil && surfaceColor == nil {
            // Using system colors, use dynamic text colors
            finalOnSurface = defaultColors.onSurface
            finalOnBackground = defaultColors.onBackground
        } else {
            // Using custom colors, use appropriate contrasting colors
            finalOnSurface = defaultColors.onSurface
            finalOnBackground = defaultColors.onBackground
        }

        // Create the custom theme with the finalized colors
        let customColors = VoticeColors(primary: finalPrimary,
                                        secondary: finalSecondary,
                                        accent: finalAccent,
                                        background: finalBackground,
                                        surface: finalSurface,
                                        onSurface: finalOnSurface,
                                        onBackground: finalOnBackground,
                                        success: finalSuccess,
                                        warning: finalWarning,
                                        error: finalError,
                                        upvote: finalSuccess,
                                        downvote: finalDestructive,
                                        pending: finalPending,
                                        accepted: finalAccepted,
                                        inProgress: finalInProgress,
                                        completed: finalCompleted,
                                        rejected: finalRejected)

        // Return the complete theme with default typography, spacing, and corner radius
        return VoticeTheme(colors: customColors, typography: .default, spacing: .default, cornerRadius: .default)
    }

    /// Get a default theme
    public static func defaultTheme() -> VoticeTheme {
        createTheme()
    }

    // MARK: - Text Customization

    public static func setTexts(_ texts: VoticeTextsProtocol) {
        TextManager.shared.setTexts(texts)
    }

    /// Reset texts to the default English implementation
    public static func resetTextsToDefault() {
        TextManager.shared.resetToDefault()
    }

    // MARK: - Font Customization

    /// Configure custom fonts for the Votice SDK
    /// - Parameter configuration: Font configuration with custom font family and weights
    /// - Note: If no custom fonts are configured, the SDK will use system fonts
    ///
    /// Example usage:
    /// ```swift
    /// let poppinsConfig = VoticeFontConfiguration(
    ///     fontFamily: "Poppins",
    ///     weights: [
    ///         .regular: "Poppins-Regular",
    ///         .medium: "Poppins-Medium",
    ///         .semiBold: "Poppins-SemiBold",
    ///         .bold: "Poppins-Bold"
    ///     ]
    /// )
    /// Votice.setFonts(poppinsConfig)
    /// ```
    public static func setFonts(_ configuration: VoticeFontConfiguration) {
        FontManager.shared.setFontConfiguration(configuration)
    }

    /// Reset fonts to the system default fonts
    public static func resetFontsToSystem() {
        FontManager.shared.resetToSystemFonts()
    }

    /// Create a theme with custom fonts applied
    /// - Parameters:
    ///   - primaryColor: Primary color for buttons and accents
    ///   - backgroundColor: Background color for the interface
    ///   - surfaceColor: Surface color for cards and components
    /// - Returns: A theme with current font configuration applied
    public static func createThemeWithCurrentFonts(primaryColor: Color? = nil,
                                                   backgroundColor: Color? = nil,
                                                   surfaceColor: Color? = nil) -> VoticeTheme {
        let colors = createAdvancedTheme(primaryColor: primaryColor,
                                         backgroundColor: backgroundColor,
                                         surfaceColor: surfaceColor).colors

        return VoticeTheme(colors: colors,
                           typography: .withCurrentFonts(),
                           spacing: .default,
                           cornerRadius: .default)
    }

    /// Get a system theme with custom fonts applied
    /// - Returns: A system theme that uses current font configuration
    public static func systemThemeWithCurrentFonts() -> VoticeTheme {
        VoticeTheme(colors: systemTheme().colors,
                    typography: .withCurrentFonts(),
                    spacing: .default,
                    cornerRadius: .default)
    }

    // MARK: - Legacy (deprecated)

    @available(*, deprecated, message: "Use configure(apiKey:apiSecret:appId:) instead")
    public static func initialize() {
        debugPrint("Hello, World!")
    }
}
