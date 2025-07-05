//
//  VoticeFontConfigurationTests.swift
//  VoticeTests
//
//  Created by Arturo Carretero Calvo on 3/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice

@Suite("VoticeFontConfiguration Tests")
struct VoticeFontConfigurationTests {
    @Test("VoticeFontConfiguration should initialize with system default")
    func testSystemDefault() {
        let config = VoticeFontConfiguration.system

        #expect(config.fontFamily == nil)
        #expect(config.weights.isEmpty)
        #expect(config.hasCustomFonts == false)
    }

    @Test("VoticeFontConfiguration should initialize with custom fonts")
    func testCustomFonts() {
        let config = VoticeFontConfiguration(
            fontFamily: "Poppins",
            weights: [
                .regular: "Poppins-Regular",
                .bold: "Poppins-Bold"
            ]
        )

        #expect(config.fontFamily == "Poppins")
        #expect(config.weights.count == 2)
        #expect(config.hasCustomFonts == true)
    }

    @Test("VoticeFontConfiguration should get font name for weight")
    func testFontNameForWeight() {
        let config = VoticeFontConfiguration(
            fontFamily: "Poppins",
            weights: [
                .regular: "Poppins-Regular",
                .bold: "Poppins-Bold"
            ]
        )

        #expect(config.fontName(for: .regular) == "Poppins-Regular")
        #expect(config.fontName(for: .bold) == "Poppins-Bold")
    }

    @Test("VoticeFontConfiguration should fallback to regular weight")
    func testFallbackToRegular() {
        let config = VoticeFontConfiguration(
            fontFamily: "Poppins",
            weights: [
                .regular: "Poppins-Regular"
            ]
        )

        // Should fallback to regular for missing weights
        #expect(config.fontName(for: .bold) == "Poppins-Regular")
        #expect(config.fontName(for: .medium) == "Poppins-Regular")
    }

    @Test("VoticeFontConfiguration should fallback to font family name")
    func testFallbackToFontFamily() {
        let config = VoticeFontConfiguration(
            fontFamily: "Poppins",
            weights: [:]
        )

        // Should fallback to font family name when no weights are specified
        #expect(config.fontName(for: .regular) == "Poppins")
        #expect(config.fontName(for: .bold) == "Poppins")
    }

    @Test("VoticeFontConfiguration should return nil for system fonts")
    func testSystemFontReturnsNil() {
        let config = VoticeFontConfiguration.system

        #expect(config.fontName(for: .regular) == nil)
        #expect(config.fontName(for: .bold) == nil)
    }

    @Test("FontWeight should have all cases")
    func testFontWeightCases() {
        let allCases = FontWeight.allCases

        #expect(allCases.count == 9)
        #expect(allCases.contains(.ultraLight))
        #expect(allCases.contains(.thin))
        #expect(allCases.contains(.light))
        #expect(allCases.contains(.regular))
        #expect(allCases.contains(.medium))
        #expect(allCases.contains(.semiBold))
        #expect(allCases.contains(.bold))
        #expect(allCases.contains(.heavy))
        #expect(allCases.contains(.black))
    }

    @Test("FontWeight should have correct raw values")
    func testFontWeightRawValues() {
        #expect(FontWeight.regular.rawValue == "regular")
        #expect(FontWeight.bold.rawValue == "bold")
        #expect(FontWeight.semiBold.rawValue == "semiBold")
    }
}
