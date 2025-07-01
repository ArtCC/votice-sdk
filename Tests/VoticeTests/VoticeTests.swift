//
//  VoticeTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice

@Test("Votice should initialize successfully")
func testInitializePrintsSomething() {
    Votice.initialize()

    #expect(Bool(true))
}
