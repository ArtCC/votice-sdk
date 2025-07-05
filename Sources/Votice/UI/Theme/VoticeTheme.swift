//
//  VoticeTheme.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

// MARK: - Votice Theme

public struct VoticeTheme {
    // MARK: Properties

    public let colors: VoticeColors
    public let typography: VoticeTypography
    public let spacing: VoticeSpacing
    public let cornerRadius: VoticeCornerRadius

    public static let `default` = VoticeTheme(colors: .default,
                                              typography: .default,
                                              spacing: .default,
                                              cornerRadius: .default)

    // MARK: Init

    public init(colors: VoticeColors,
                typography: VoticeTypography,
                spacing: VoticeSpacing,
                cornerRadius: VoticeCornerRadius) {
        self.colors = colors
        self.typography = typography
        self.spacing = spacing
        self.cornerRadius = cornerRadius
    }
}

// MARK: - Votice Colors

public struct VoticeColors {
    // MARK: Properties

    public let primary: Color
    public let secondary: Color
    public let accent: Color
    public let background: Color
    public let surface: Color
    public let onSurface: Color
    public let onBackground: Color
    public let success: Color
    public let warning: Color
    public let error: Color
    public let upvote: Color
    public let downvote: Color
    public let pending: Color
    public let accepted: Color
    public let inProgress: Color
    public let completed: Color
    public let rejected: Color

    public static let `default` = VoticeColors(primary: Color(red: 0.0, green: 0.48, blue: 1.0),      // iOS Blue
                                               secondary: Color(red: 0.56, green: 0.56, blue: 0.58),   // Modern Gray
                                               accent: Color(red: 1.0, green: 0.58, blue: 0.0),        // Vibrant Orange
                                               background: Color.systemBackground,
                                               surface: Color.secondarySystemBackground,
                                               onSurface: Color.primary,
                                               onBackground: Color.primary,
                                               success: Color(red: 0.20, green: 0.78, blue: 0.35),     // Modern Green
                                               warning: Color(red: 1.0, green: 0.58, blue: 0.0),       // Warm Orange
                                               error: Color(red: 1.0, green: 0.23, blue: 0.19),        // Modern Red
                                               upvote: Color(red: 0.20, green: 0.78, blue: 0.35),      // Success Green
                                               downvote: Color(red: 1.0, green: 0.23, blue: 0.19),     // Error Red
                                               pending: Color(red: 1.0, green: 0.58, blue: 0.0),       // Warning Orange
                                               accepted: Color(red: 0.0, green: 0.48, blue: 1.0),      // Primary Blue
                                               inProgress: Color(red: 0.48, green: 0.40, blue: 0.93),  // Modern Purple
                                               completed: Color(red: 0.20, green: 0.78, blue: 0.35),   // Success Green
                                               rejected: Color(red: 1.0, green: 0.23, blue: 0.19))     // Error Red

    // MARK: Init

    public init(primary: Color,
                secondary: Color,
                accent: Color,
                background: Color,
                surface: Color,
                onSurface: Color,
                onBackground: Color,
                success: Color,
                warning: Color,
                error: Color,
                upvote: Color,
                downvote: Color,
                pending: Color,
                accepted: Color,
                inProgress: Color,
                completed: Color,
                rejected: Color) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.onSurface = onSurface
        self.onBackground = onBackground
        self.success = success
        self.warning = warning
        self.error = error
        self.upvote = upvote
        self.downvote = downvote
        self.pending = pending
        self.accepted = accepted
        self.inProgress = inProgress
        self.completed = completed
        self.rejected = rejected
    }
}

// MARK: - Color Extensions

extension Color {
    static var systemBackground: Color {
#if os(iOS)
        return Color(UIColor.systemBackground)
#elseif os(macOS)
        return Color(NSColor.windowBackgroundColor)
#elseif os(tvOS)
        return Color.black
#else
        return Color.white
#endif
    }

    static var secondarySystemBackground: Color {
#if os(iOS)
        return Color(UIColor.secondarySystemBackground)
#elseif os(macOS)
        return Color(NSColor.controlBackgroundColor)
#elseif os(tvOS)
        return Color.gray
#else
        return Color.white
#endif
    }
}

// MARK: - Votice Typography

public struct VoticeTypography {
    // MARK: Properties

    public let largeTitle: Font
    public let title: Font
    public let title2: Font
    public let title3: Font
    public let headline: Font
    public let subheadline: Font
    public let body: Font
    public let callout: Font
    public let footnote: Font
    public let caption: Font
    public let caption2: Font

    public static let `default` = VoticeTypography(largeTitle: FontManager.shared.font(for: .bold, size: 34),
                                                   title: FontManager.shared.font(for: .bold, size: 28),
                                                   title2: FontManager.shared.font(for: .bold, size: 22),
                                                   title3: FontManager.shared.font(for: .semiBold, size: 20),
                                                   headline: FontManager.shared.font(for: .semiBold, size: 17),
                                                   subheadline: FontManager.shared.font(for: .regular, size: 15),
                                                   body: FontManager.shared.font(for: .regular, size: 17),
                                                   callout: FontManager.shared.font(for: .regular, size: 16),
                                                   footnote: FontManager.shared.font(for: .regular, size: 13),
                                                   caption: FontManager.shared.font(for: .regular, size: 12),
                                                   caption2: FontManager.shared.font(for: .regular, size: 11))

    // MARK: Init

    public init(largeTitle: Font,
                title: Font,
                title2: Font,
                title3: Font,
                headline: Font,
                subheadline: Font,
                body: Font,
                callout: Font,
                footnote: Font,
                caption: Font,
                caption2: Font) {
        self.largeTitle = largeTitle
        self.title = title
        self.title2 = title2
        self.title3 = title3
        self.headline = headline
        self.subheadline = subheadline
        self.body = body
        self.callout = callout
        self.footnote = footnote
        self.caption = caption
        self.caption2 = caption2
    }

    /// Create a typography configuration using the current font manager settings
    public static func withCurrentFonts() -> VoticeTypography {
        return VoticeTypography(
            largeTitle: FontManager.shared.font(for: .bold, size: 34),
            title: FontManager.shared.font(for: .bold, size: 28),
            title2: FontManager.shared.font(for: .bold, size: 22),
            title3: FontManager.shared.font(for: .semiBold, size: 20),
            headline: FontManager.shared.font(for: .semiBold, size: 17),
            subheadline: FontManager.shared.font(for: .regular, size: 15),
            body: FontManager.shared.font(for: .regular, size: 17),
            callout: FontManager.shared.font(for: .regular, size: 16),
            footnote: FontManager.shared.font(for: .regular, size: 13),
            caption: FontManager.shared.font(for: .regular, size: 12),
            caption2: FontManager.shared.font(for: .regular, size: 11)
        )
    }
}

// MARK: - Votice Spacing

public struct VoticeSpacing {
    public let xs: CGFloat = 4
    public let sm: CGFloat = 8
    public let md: CGFloat = 16
    public let lg: CGFloat = 24
    public let llg: CGFloat = 28
    public let xl: CGFloat = 32
    public let xxl: CGFloat = 48
    public let xxxl: CGFloat = 60
    public let xxxxl: CGFloat = 80

    public static let `default` = VoticeSpacing()

    public init() {}
}

// MARK: - Votice Corner Radius

public struct VoticeCornerRadius {
    // MARK: Properties

    public let xs: CGFloat = 4
    public let sm: CGFloat = 8
    public let md: CGFloat = 12
    public let lg: CGFloat = 16
    public let xl: CGFloat = 20

    public static let `default` = VoticeCornerRadius()

    // MARK: Init

    public init() {
    }
}

// MARK: - Theme Environment Key

private struct VoticeThemeKey: EnvironmentKey {
    // MARK: Properties

    typealias Value = VoticeTheme

    static let defaultValue = VoticeTheme.default
}

extension EnvironmentValues {
    var voticeTheme: VoticeTheme {
        get { self[VoticeThemeKey.self] }
        set { self[VoticeThemeKey.self] = newValue }
    }
}
