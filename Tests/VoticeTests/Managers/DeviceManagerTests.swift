//
//  DeviceManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("DeviceManager should generate valid device ID")
func testDeviceIdGeneration() async {
    // Given
    let deviceManager = DeviceManager.shared

    // When
    let deviceId = deviceManager.deviceId

    // Then
    #expect(!deviceId.isEmpty)
    #expect(deviceId.count == 36) // UUID format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX
    #expect(UUID(uuidString: deviceId) != nil) // Should be valid UUID
}

@Test("DeviceManager should persist device ID")
func testDeviceIdPersistence() async {
    // Given
    let deviceManager = DeviceManager.shared

    // When
    let firstCall = deviceManager.deviceId
    let secondCall = deviceManager.deviceId

    // Then
    #expect(firstCall == secondCall)
}

@Test("DeviceManager should generate new device ID when requested")
func testGenerateNewDeviceId() async {
    // Given
    let deviceManager = DeviceManager.shared
    deviceManager.resetDeviceId() // Start fresh
    let originalId = deviceManager.deviceId

    // When
    let newId = deviceManager.generateNewDeviceId()

    // Then
    #expect(newId != originalId)
    #expect(!newId.isEmpty)
    #expect(UUID(uuidString: newId) != nil)

    // The current deviceId should now be the new one
    let currentId = deviceManager.deviceId
    #expect(currentId == newId)
}

@Test("DeviceManager should reset device ID")
func testResetDeviceId() async {
    // Given
    let deviceManager = DeviceManager.shared
    let originalId = deviceManager.deviceId

    // When
    deviceManager.resetDeviceId()
    let newId = deviceManager.deviceId

    // Then
    #expect(newId != originalId)
    #expect(!newId.isEmpty)
    #expect(UUID(uuidString: newId) != nil)
}

@Test("DeviceManager should provide valid platform")
func testPlatform() async {
    // Given
    let deviceManager = DeviceManager.shared

    // When
    let platform = deviceManager.platform

    // Then
    #expect(!platform.isEmpty)

    // Should be one of the expected platforms
    let validPlatforms = ["iOS", "iPadOS", "macOS", "macCatalyst", "watchOS", "tvOS", "visionOS", "Unknown"]
    #expect(validPlatforms.contains(platform))
}

@Test("DeviceManager should provide valid language")
func testLanguage() async {
    // Given
    let deviceManager = DeviceManager.shared

    // When
    let language = deviceManager.language

    // Then
    #expect(!language.isEmpty)
    #expect(language.count >= 2) // Should be at least 2 characters (e.g., "en", "es")
}

@Test("DeviceManager should be thread-safe")
func testThreadSafety() async {
    // Given
    let deviceManager = DeviceManager.shared

    // When - Concurrent access
    await withTaskGroup(of: String.self) { group in
        for _ in 0..<10 {
            group.addTask {
                return deviceManager.deviceId
            }
        }

        var results: [String] = []
        for await result in group {
            results.append(result)
        }

        // Then - All results should be valid UUIDs (no crashes)
        for result in results {
            #expect(!result.isEmpty)
            #expect(UUID(uuidString: result) != nil)
        }

        // Thread safety means no crashes or empty results
        #expect(results.count == 10)
    }
}
