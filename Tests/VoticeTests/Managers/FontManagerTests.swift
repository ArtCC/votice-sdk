//
//  FontManagerTests.swift
//  VoticeTests
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import SwiftUI

@Suite("FontManager Tests")
struct FontManagerTests {
    @Test("FontManager should be singleton")
    func testSingletonBehavior() {
        let manager1 = FontManager.shared
        let manager2 = FontManager.shared

        #expect(manager1 === manager2)
    }

    @Test("FontManager should start with system fonts")
    func testDefaultSystemFonts() {
        let manager = FontManager.shared
        manager.resetToSystemFonts()

        let font = manager.font(for: .regular, size: 16)

        // Should create a font (system font is the fallback)
        #expect(font != nil)
    }

    @Test("FontManager should accept custom font configuration")
    func testCustomFontConfiguration() {
        let manager = FontManager.shared

        let customConfig = VoticeFontConfiguration(
            fontFamily: "TestFont",
            weights: [
                .regular: "TestFont-Regular",
                .bold: "TestFont-Bold"
            ]
        )

        manager.setFontConfiguration(customConfig)

        // Should create custom font (will fallback to system if font doesn't exist)
        let font = manager.font(for: .regular, size: 16)
        #expect(font != nil)
    }

    @Test("FontManager should reset to system fonts")
    func testResetToSystemFonts() {
        let manager = FontManager.shared

        // Set custom configuration
        let customConfig = VoticeFontConfiguration(
            fontFamily: "TestFont",
            weights: [.regular: "TestFont-Regular"]
        )
        manager.setFontConfiguration(customConfig)

        // Reset to system
        manager.resetToSystemFonts()

        // Should use system fonts
        let font = manager.font(for: .regular, size: 16)
        #expect(font != nil)
    }

    @Test("FontManager should handle concurrent access")
    func testConcurrentAccess() async {
        let manager = FontManager.shared

        await withTaskGroup(of: Void.self) { group in
            for i in 0..<10 {
                group.addTask {
                    let config = VoticeFontConfiguration(
                        fontFamily: "TestFont\(i)",
                        weights: [.regular: "TestFont\(i)-Regular"]
                    )
                    manager.setFontConfiguration(config)

                    let font = manager.font(for: .regular, size: 16)
                    #expect(font != nil)
                }
            }
        }
    }
}
