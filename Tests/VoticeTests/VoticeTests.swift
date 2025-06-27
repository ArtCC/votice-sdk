//
//  VoticeTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//

import Testing
@testable import Votice

@Test
struct VoticeTests {
    func testInitializePrintsSomething() {
        Votice.initialize()

        #expect(true)
    }
}
