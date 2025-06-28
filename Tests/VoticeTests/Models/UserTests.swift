//
//  UserTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("UserEntity should initialize correctly")
func testUserInitialization() async {
    // Given
    let id = "user-123"
    let email = "john@example.com"
    let name = "John Doe"
    let plan = UserPlan.pro
    let appCount = 3
    let language = "en"
    let fcmToken = "fcm-token-abc"
    let createdAt = Date()
    let updatedAt = Date()

    // When
    let user = UserEntity(
        id: id,
        email: email,
        name: name,
        plan: plan,
        appCount: appCount,
        language: language,
        fcmToken: fcmToken,
        createdAt: createdAt,
        updatedAt: updatedAt
    )

    // Then
    #expect(user.id == id)
    #expect(user.email == email)
    #expect(user.name == name)
    #expect(user.plan == plan)
    #expect(user.appCount == appCount)
    #expect(user.language == language)
    #expect(user.fcmToken == fcmToken)
    #expect(user.createdAt == createdAt)
    #expect(user.updatedAt == updatedAt)
}

@Test("UserEntity should encode and decode correctly")
func testUserCodable() async throws {
    // Given
    let originalUser = UserEntity(
        id: "user-123",
        email: "john@example.com",
        name: "John Doe",
        plan: .pro,
        appCount: 3,
        language: "en",
        fcmToken: "fcm-token-abc",
        createdAt: Date(timeIntervalSince1970: 1640995200),
        updatedAt: Date(timeIntervalSince1970: 1640995200)
    )

    // When
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let encodedData = try encoder.encode(originalUser)

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    let decodedUser = try decoder.decode(UserEntity.self, from: encodedData)

    // Then
    #expect(decodedUser.id == originalUser.id)
    #expect(decodedUser.email == originalUser.email)
    #expect(decodedUser.name == originalUser.name)
    #expect(decodedUser.plan == originalUser.plan)
    #expect(decodedUser.appCount == originalUser.appCount)
    #expect(decodedUser.language == originalUser.language)
    #expect(decodedUser.fcmToken == originalUser.fcmToken)
}

@Test("UserEntity push notifications status should work correctly")
func testUserPushNotifications() async {
    // Given & When & Then
    let userWithToken = UserEntity(
        id: "1", email: "test@example.com", name: "Test",
        plan: .free, appCount: 0, language: "en",
        fcmToken: "valid-token",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(userWithToken.hasPushNotifications)

    let userWithoutToken = UserEntity(
        id: "2", email: "test@example.com", name: "Test",
        plan: .free, appCount: 0, language: "en",
        fcmToken: nil,
        createdAt: Date(), updatedAt: Date()
    )
    #expect(!userWithoutToken.hasPushNotifications)

    let userWithEmptyToken = UserEntity(
        id: "3", email: "test@example.com", name: "Test",
        plan: .free, appCount: 0, language: "en",
        fcmToken: "",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(!userWithEmptyToken.hasPushNotifications)
}

@Test("UserEntity plan status should work correctly")
func testUserPlanStatus() async {
    // Given & When & Then
    let freeUser = UserEntity(
        id: "1", email: "test@example.com", name: "Test",
        plan: .free, appCount: 0, language: "en",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(!freeUser.isPaidPlan)

    let proUser = UserEntity(
        id: "2", email: "test@example.com", name: "Test",
        plan: .pro, appCount: 0, language: "en",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(proUser.isPaidPlan)

    let enterpriseUser = UserEntity(
        id: "3", email: "test@example.com", name: "Test",
        plan: .enterprise, appCount: 0, language: "en",
        createdAt: Date(), updatedAt: Date()
    )
    #expect(enterpriseUser.isPaidPlan)
}

@Test("UserPlan should have all expected cases")
func testUserPlanCases() async {
    let expectedPlans: [UserPlan] = [.free, .pro, .enterprise]

    #expect(UserPlan.allCases.count == 3)

    for plan in expectedPlans {
        #expect(UserPlan.allCases.contains(plan))
    }
}
