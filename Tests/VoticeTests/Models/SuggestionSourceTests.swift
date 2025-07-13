//
//  SuggestionSourceTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import Foundation

// MARK: - SuggestionSource Tests

@Test("SuggestionSource should have correct raw values")
func testSuggestionSourceRawValues() async {
    // Given/When/Then
    #expect(SuggestionSource.dashboard.rawValue == "dashboard")
    #expect(SuggestionSource.sdk.rawValue == "sdk")
}

@Test("SuggestionSource should initialize from raw values")
func testSuggestionSourceFromRawValue() async {
    // Given/When/Then
    #expect(SuggestionSource(rawValue: "dashboard") == .dashboard)
    #expect(SuggestionSource(rawValue: "sdk") == .sdk)
    #expect(SuggestionSource(rawValue: "invalid") == nil)
    #expect(SuggestionSource(rawValue: "") == nil)
}

@Test("SuggestionSource should provide all cases")
func testSuggestionSourceAllCases() async {
    // Given/When
    let allCases = SuggestionSource.allCases

    // Then
    #expect(allCases.count == 2)
    #expect(allCases.contains(.dashboard))
    #expect(allCases.contains(.sdk))
}

@Test("SuggestionSource should be Codable")
func testSuggestionSourceCodable() async throws {
    // Given
    let sources = [SuggestionSource.dashboard, SuggestionSource.sdk]

    // When - Encode
    let encoder = JSONEncoder()
    let data = try encoder.encode(sources)

    // Then - Decode
    let decoder = JSONDecoder()
    let decoded = try decoder.decode([SuggestionSource].self, from: data)

    #expect(decoded.count == 2)
    #expect(decoded[0] == .dashboard)
    #expect(decoded[1] == .sdk)
}

@Test("SuggestionSource should encode to JSON strings")
func testSuggestionSourceJSONEncoding() async throws {
    // Given
    let dashboardSource = SuggestionSource.dashboard
    let sdkSource = SuggestionSource.sdk

    // When
    let encoder = JSONEncoder()
    let dashboardData = try encoder.encode(dashboardSource)
    let sdkData = try encoder.encode(sdkSource)

    let dashboardJSON = String(data: dashboardData, encoding: .utf8)
    let sdkJSON = String(data: sdkData, encoding: .utf8)

    // Then
    #expect(dashboardJSON == "\"dashboard\"")
    #expect(sdkJSON == "\"sdk\"")
}

@Test("SuggestionSource should decode from JSON strings")
func testSuggestionSourceJSONDecoding() async throws {
    // Given
    let dashboardJSON = "\"dashboard\""
    let sdkJSON = "\"sdk\""
    let invalidJSON = "\"invalid\""

    let dashboardData = Data(dashboardJSON.utf8)
    let sdkData = Data(sdkJSON.utf8)
    let invalidData = Data(invalidJSON.utf8)

    // When/Then
    let decoder = JSONDecoder()

    let dashboardSource = try decoder.decode(SuggestionSource.self, from: dashboardData)
    #expect(dashboardSource == .dashboard)

    let sdkSource = try decoder.decode(SuggestionSource.self, from: sdkData)
    #expect(sdkSource == .sdk)

    // Invalid value should throw
    await #expect(throws: DecodingError.self) {
        _ = try decoder.decode(SuggestionSource.self, from: invalidData)
    }
}

@Test("SuggestionSource should be Sendable")
func testSuggestionSourceSendable() async {
    // Given
    let source = SuggestionSource.sdk

    // When - This compiles, proving it's Sendable
    Task {
        _ = source.rawValue
        let allCases = SuggestionSource.allCases
        _ = allCases.count
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}

@Test("SuggestionSource should work in collections")
func testSuggestionSourceInCollections() async {
    // Given
    let sources = [SuggestionSource.dashboard, SuggestionSource.sdk]
    let sourceSet = Set([SuggestionSource.dashboard, SuggestionSource.sdk, SuggestionSource.dashboard])

    // When/Then
    #expect(sources.count == 2)
    #expect(sources[0] == .dashboard)
    #expect(sources[1] == .sdk)

    #expect(sourceSet.count == 2) // Set should remove duplicates
    #expect(sourceSet.contains(.dashboard))
    #expect(sourceSet.contains(.sdk))
}

@Test("SuggestionSource should support switch statements")
func testSuggestionSourceSwitchStatement() async {
    // Given
    let sources = SuggestionSource.allCases

    // When/Then
    for source in sources {
        let description = switch source {
        case .dashboard:
            "Dashboard"
        case .sdk:
            "SDK"
        }

        switch source {
        case .dashboard:
            #expect(description == "Dashboard")
        case .sdk:
            #expect(description == "SDK")
        }
    }
}
