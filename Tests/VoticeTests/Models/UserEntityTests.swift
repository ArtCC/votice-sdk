//
//  UserEntityTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import VoticeSDK
import Foundation

// MARK: - UserEntity Tests

@Test("UserEntity should initialize correctly with premium user")
func testUserEntityPremiumInitialization() async {
    // Given/When
    let premiumUser = UserEntity(isPremium: true)

    // Then
    #expect(premiumUser.isPremium == true)
}

@Test("UserEntity should initialize correctly with free user")
func testUserEntityFreeInitialization() async {
    // Given/When
    let freeUser = UserEntity(isPremium: false)

    // Then
    #expect(freeUser.isPremium == false)
}

@Test("UserEntity should be Codable")
func testUserEntityCodable() async throws {
    // Given
    let originalPremium = UserEntity(isPremium: true)
    let originalFree = UserEntity(isPremium: false)

    // When - Encode premium user
    let encoder = JSONEncoder()
    let premiumData = try encoder.encode(originalPremium)
    let freeData = try encoder.encode(originalFree)

    // Then - Decode
    let decoder = JSONDecoder()
    let decodedPremium = try decoder.decode(UserEntity.self, from: premiumData)
    let decodedFree = try decoder.decode(UserEntity.self, from: freeData)

    #expect(decodedPremium.isPremium == true)
    #expect(decodedFree.isPremium == false)
}

@Test("UserEntity should handle JSON with explicit boolean values")
func testUserEntityJSONDecoding() async throws {
    // Given
    let premiumJsonString = """
    {
        "isPremium": true
    }
    """

    let freeJsonString = """
    {
        "isPremium": false
    }
    """

    let premiumJsonData = Data(premiumJsonString.utf8)
    let freeJsonData = Data(freeJsonString.utf8)

    // When
    let decoder = JSONDecoder()
    let premiumUser = try decoder.decode(UserEntity.self, from: premiumJsonData)
    let freeUser = try decoder.decode(UserEntity.self, from: freeJsonData)

    // Then
    #expect(premiumUser.isPremium == true)
    #expect(freeUser.isPremium == false)
}

@Test("UserEntity should be Sendable")
func testUserEntitySendable() async {
    // Given
    let user = UserEntity(isPremium: true)

    // When - This compiles, proving it's Sendable
    Task {
        _ = user.isPremium
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}

@Test("UserEntity should work with arrays and collections")
func testUserEntityCollections() async {
    // Given
    let users = [
        UserEntity(isPremium: true),
        UserEntity(isPremium: false),
        UserEntity(isPremium: true)
    ]

    // When
    let premiumUsers = users.filter { $0.isPremium }
    let freeUsers = users.filter { !$0.isPremium }

    // Then
    #expect(premiumUsers.count == 2)
    #expect(freeUsers.count == 1)
    #expect(premiumUsers.allSatisfy { $0.isPremium })
    #expect(freeUsers.allSatisfy { !$0.isPremium })
}
