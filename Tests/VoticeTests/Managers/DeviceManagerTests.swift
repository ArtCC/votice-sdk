//
//  DeviceManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import Foundation

// MARK: - DeviceManager Tests

@Test("DeviceManager should generate a device ID automatically")
func testDeviceManagerGeneratesDeviceID() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)

    // When
    let deviceId = manager.deviceId

    // Then
    #expect(!deviceId.isEmpty)
    #expect(deviceId.count == 36) // UUID format: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX

    // Should be consistent across calls
    let deviceId2 = manager.deviceId
    #expect(deviceId == deviceId2)
}

@Test("DeviceManager should return correct platform")
func testDeviceManagerPlatform() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)

    // When
    let platform = manager.platform

    // Then
    #expect(!platform.isEmpty)

    // Platform should be one of the expected values
    let expectedPlatforms = ["iOS", "iPadOS", "macOS", "watchOS", "tvOS", "visionOS", "macCatalyst", "Unknown"]
    #expect(expectedPlatforms.contains(platform))

    // For macOS testing, it should be "macOS"
    #if os(macOS)
    #expect(platform == "macOS")
    #endif
}

@Test("DeviceManager should return valid language code")
func testDeviceManagerLanguage() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)

    // When
    let language = manager.language

    // Then
    #expect(!language.isEmpty)
    #expect(language.count >= 2) // Language codes are at least 2 characters

    // Should be a valid language code format or fallback to "en"
    #expect(language.allSatisfy { $0.isLetter || $0 == "-" } || language == "en")
}

@Test("DeviceManager should generate new device ID when requested")
func testDeviceManagerGenerateNewDeviceID() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    let originalDeviceId = manager.deviceId

    // When
    let newDeviceId = manager.generateNewDeviceId()

    // Then
    #expect(newDeviceId != originalDeviceId)
    #expect(!newDeviceId.isEmpty)
    #expect(newDeviceId.count == 36) // UUID format

    // Device ID should now return the new one
    #expect(manager.deviceId == newDeviceId)
}

@Test("DeviceManager should reset device ID")
func testDeviceManagerResetDeviceID() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    let originalDeviceId = manager.deviceId
    #expect(!originalDeviceId.isEmpty)

    // When
    manager.resetDeviceId()

    // Then
    let newDeviceId = manager.deviceId
    #expect(newDeviceId != originalDeviceId)
    #expect(!newDeviceId.isEmpty)
    #expect(newDeviceId.count == 36) // UUID format
}

@Test("DeviceManager should be thread-safe for device ID access")
func testDeviceManagerThreadSafety() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    var deviceIds: [String] = []
    let lock = NSLock()

    // When - Access device ID from multiple threads concurrently
    await withTaskGroup(of: String.self) { group in
        for _ in 0..<10 {
            group.addTask {
                return manager.deviceId
            }
        }

        for await deviceId in group {
            lock.withLock {
                deviceIds.append(deviceId)
            }
        }
    }

    // Then - All device IDs should be the same (consistent)
    #expect(deviceIds.count == 10)
    let firstDeviceId = deviceIds.first!
    for deviceId in deviceIds {
        #expect(deviceId == firstDeviceId)
    }
}

@Test("DeviceManager should be thread-safe for device ID generation")
func testDeviceManagerGenerationThreadSafety() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    var generatedIds: [String] = []
    let lock = NSLock()

    // When - Generate device IDs from multiple threads concurrently
    await withTaskGroup(of: String.self) { group in
        for _ in 0..<5 {
            group.addTask {
                return manager.generateNewDeviceId()
            }
        }

        for await deviceId in group {
            lock.withLock {
                generatedIds.append(deviceId)
            }
        }
    }

    // Then - Each generated ID should be unique
    #expect(generatedIds.count == 5)
    let uniqueIds = Set(generatedIds)
    #expect(uniqueIds.count == 5) // All should be unique

    // All should be valid UUID format
    for deviceId in generatedIds {
        #expect(deviceId.count == 36)
        #expect(!deviceId.isEmpty)
    }
}

@Test("DeviceManager properties should be consistent across calls")
func testDeviceManagerConsistency() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)

    // When
    let platform1 = manager.platform
    let platform2 = manager.platform
    let language1 = manager.language
    let language2 = manager.language

    // Then
    #expect(platform1 == platform2)
    #expect(language1 == language2)
}

@Test("DeviceManager should conform to DeviceManagerProtocol")
func testDeviceManagerProtocolConformance() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    let protocolManager: DeviceManagerProtocol = manager

    // When/Then - Should be able to access all protocol properties
    let deviceId = protocolManager.deviceId
    let platform = protocolManager.platform
    let language = protocolManager.language

    #expect(!deviceId.isEmpty)
    #expect(!platform.isEmpty)
    #expect(!language.isEmpty)
}

@Test("DeviceManager should be Sendable")
func testDeviceManagerSendable() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)

    // When - This compiles, proving it's Sendable
    Task {
        _ = manager.deviceId
        _ = manager.platform
        _ = manager.language
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}

// MARK: - Edge Cases Tests

@Test("DeviceManager should handle multiple resets correctly")
func testDeviceManagerMultipleResets() async {
    // Given
    let testUserDefaults = UserDefaults(suiteName: "test-\(UUID().uuidString)")!
    let manager = DeviceManager(userDefaults: testUserDefaults)
    var previousIds: [String] = []

    // When - Reset multiple times
    for _ in 0..<5 {
        manager.resetDeviceId()
        let deviceId = manager.deviceId
        #expect(!previousIds.contains(deviceId)) // Should be unique
        previousIds.append(deviceId)
    }

    // Then
    #expect(previousIds.count == 5)
    #expect(Set(previousIds).count == 5) // All unique
}

@Test("DeviceManager should maintain singleton behavior")
func testDeviceManagerSingleton() async {
    // Given/When
    let manager1 = DeviceManager.shared
    let manager2 = DeviceManager.shared

    // Then
    #expect(manager1 === manager2) // Same instance
    #expect(manager1.deviceId == manager2.deviceId) // Same device ID
}

@Test("DeviceManager should work with different UserDefaults instances")
func testDeviceManagerWithDifferentUserDefaults() async {
    // Given
    let userDefaults1 = UserDefaults(suiteName: "test-1-\(UUID().uuidString)")!
    let userDefaults2 = UserDefaults(suiteName: "test-2-\(UUID().uuidString)")!
    let manager1 = DeviceManager(userDefaults: userDefaults1)
    let manager2 = DeviceManager(userDefaults: userDefaults2)

    // When
    let deviceId1 = manager1.deviceId
    let deviceId2 = manager2.deviceId

    // Then
    #expect(deviceId1 != deviceId2) // Different UserDefaults should have different device IDs
    #expect(!deviceId1.isEmpty)
    #expect(!deviceId2.isEmpty)
}
