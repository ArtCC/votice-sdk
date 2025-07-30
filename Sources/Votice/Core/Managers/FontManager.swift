//
//  FontManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import SwiftUI

protocol FontManagerProtocol: Sendable {
    func setFontConfiguration(_ configuration: VoticeFontConfiguration)
    func resetToSystemFonts()
    func font(for weight: FontWeight, size: CGFloat) -> Font
}

final class FontManager: FontManagerProtocol, @unchecked Sendable {
    // MARK: - Properties

    static let shared = FontManager()

    private var _fontConfiguration: VoticeFontConfiguration = .system

    private let lock = NSLock()

    // MARK: - Init

    private init() {}

    // MARK: - Public functions

    func setFontConfiguration(_ configuration: VoticeFontConfiguration) {
        lock.lock()

        defer {
            lock.unlock()
        }

        _fontConfiguration = configuration

        LogManager.shared.devLog(
            .info, "FontManager: font configuration updated: \(configuration.fontFamily ?? "System")"
        )
    }

    func resetToSystemFonts() {
        lock.lock()

        defer {
            lock.unlock()
        }

        _fontConfiguration = .system

        LogManager.shared.devLog(.info, "FontManager: font configuration reset to system fonts")
    }

    func font(for weight: FontWeight, size: CGFloat) -> Font {
        lock.lock()

        let configuration = _fontConfiguration

        lock.unlock()

        // If no custom fonts are configured, use system fonts
        guard configuration.hasCustomFonts, let fontName = configuration.fontName(for: weight) else {
            return systemFont(for: weight, size: size)
        }

        // Try to create custom font
        let customFont = Font.custom(fontName, size: size)

        // Validate that the font exists (this will fallback to system font if not found)
        return customFont
    }

    // MARK: - Private

    private func systemFont(for weight: FontWeight, size: CGFloat) -> Font {
        switch weight {
        case .ultraLight:
            return Font.system(size: size, weight: .ultraLight)
        case .thin:
            return Font.system(size: size, weight: .thin)
        case .light:
            return Font.system(size: size, weight: .light)
        case .regular:
            return Font.system(size: size, weight: .regular)
        case .medium:
            return Font.system(size: size, weight: .medium)
        case .semiBold:
            return Font.system(size: size, weight: .semibold)
        case .bold:
            return Font.system(size: size, weight: .bold)
        case .heavy:
            return Font.system(size: size, weight: .heavy)
        case .black:
            return Font.system(size: size, weight: .black)
        }
    }
}
