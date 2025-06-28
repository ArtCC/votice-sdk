//
//  RequestResponseTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - Suggestion Request Tests

@Test("VoteType should encode and decode correctly")
func testVoteTypeEncodingDecoding() async throws {
    // Given
    let voteTypes: [VoteType] = [.upvote, .downvote, .remove]

    for voteType in voteTypes {
        // When
        let encodedData = try JSONEncoder().encode(voteType)
        let decodedVoteType = try JSONDecoder().decode(VoteType.self, from: encodedData)

        // Then
        #expect(decodedVoteType == voteType)
    }
}

@Test("VoteType raw values should be correct")
func testVoteTypeRawValues() async {
    // Then
    #expect(VoteType.upvote.rawValue == "upvote")
    #expect(VoteType.downvote.rawValue == "downvote")
    #expect(VoteType.remove.rawValue == "remove")
}
