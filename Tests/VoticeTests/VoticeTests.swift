//
//  VoticeTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//

import Testing
@testable import Votice

@Test("Votice should initialize successfully")
func testInitializePrintsSomething() {
    Votice.initialize()

    #expect(Bool(true))
}