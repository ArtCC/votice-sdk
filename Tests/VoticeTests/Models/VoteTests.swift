//
//  VoteTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

@Test("VoteStatusEntity should initialize correctly")
func testVoteStatusInitialization() async {
    // Given & When
    let votedStatus = VoteStatusEntity(voted: true, voteType: "upvote")
    let notVotedStatus = VoteStatusEntity(voted: false, voteType: nil)

    // Then
    #expect(votedStatus.voted == true)
    #expect(votedStatus.voteType == "upvote")
    #expect(notVotedStatus.voted == false)
    #expect(notVotedStatus.voteType == nil)
}

@Test("VoteStatusEntity should encode and decode correctly")
func testVoteStatusCodable() async throws {
    // Given
    let originalStatus = VoteStatusEntity(voted: true, voteType: "downvote")

    // When
    let encoded = try JSONEncoder().encode(originalStatus)
    let decoded = try JSONDecoder().decode(VoteStatusEntity.self, from: encoded)

    // Then
    #expect(decoded.voted == originalStatus.voted)
    #expect(decoded.voteType == originalStatus.voteType)
}
