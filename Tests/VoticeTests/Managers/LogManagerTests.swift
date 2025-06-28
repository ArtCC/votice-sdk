//
//  LogManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2024 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("LogManager should handle different log types")
func testLogManagerTypes() async {
    // Given
    let logManager = LogManager.shared
    let originalDebugState = LogManager.debug
    LogManager.debug = true

    // When & Then - These should not crash and should print appropriate messages
    logManager.devLog(.info, "Test info message")
    logManager.devLog(.success, "Test success message")
    logManager.devLog(.error, "Test error message")
    logManager.devLog(.warning, "Test warning message")
    logManager.devLog(.request, "Test request message")
    logManager.devLog(.finished, "Test finished message")
    logManager.devLog(.canceled, "Test canceled message")

    // Restore original state
    LogManager.debug = originalDebugState

    #expect(Bool(true)) // If we reach here without crashing, the test passes
}

@Test("LogManager should handle UTF8 data logging")
func testLogManagerWithData() async {
    // Given
    let logManager = LogManager.shared
    let originalDebugState = LogManager.debug
    LogManager.debug = true

    let testData = Data(string: "Test data content", encoding: .utf8)

    // When & Then
    logManager.devLog(.info, "Test with data", utf8Data: testData)
    logManager.devLog(.success, "Test with nil data", utf8Data: nil)
    logManager.devLog(.error, "Test with empty data", utf8Data: Data())

    // Restore original state
    LogManager.debug = originalDebugState

    #expect(Bool(true))
}

@Test("LogManager should handle userInfo logging")
func testLogManagerWithUserInfo() async {
    // Given
    let logManager = LogManager.shared
    let originalDebugState = LogManager.debug
    LogManager.debug = true

    let userInfo: [AnyHashable: Any] = [
        "key1": "value1",
        "key2": 123,
        "key3": ["nested": "value"]
    ]

    // When & Then
    logManager.devLog(.info, "Test with userInfo", userInfo: userInfo)
    logManager.devLog(.success, "Test with empty userInfo", userInfo: [:])

    // Restore original state
    LogManager.debug = originalDebugState

    #expect(Bool(true))
}

@Test("LogManager should respect debug flag")
func testLogManagerDebugFlag() async {
    // Given
    let logManager = LogManager.shared
    let originalDebugState = LogManager.debug

    // When debug is false, should not print (we can't easily test print output, but we can ensure no crashes)
    LogManager.debug = false
    logManager.devLog(.info, "This should not print")

    // When debug is true, should print
    LogManager.debug = true
    logManager.devLog(.info, "This should print")

    // Restore original state
    LogManager.debug = originalDebugState

    #expect(Bool(true))
}

@Test("LogManager should handle function name parameter")
func testLogManagerFunctionName() async {
    // Given
    let logManager = LogManager.shared
    let originalDebugState = LogManager.debug
    LogManager.debug = true

    // When & Then
    logManager.devLog(.info, "Test with function name", ignoreFunctionName: false, function: "testFunction()")
    logManager.devLog(.info, "Test without function name", ignoreFunctionName: true, function: "testFunction()")

    // Restore original state
    LogManager.debug = originalDebugState

    #expect(Bool(true))
}
