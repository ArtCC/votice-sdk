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

@Test("FetchSuggestionsResponse alias should work correctly")
func testFetchSuggestionsResponseAlias() async throws {
    // Given
    let json = """
    {
        "suggestions": []
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(FetchSuggestionsResponse.self, from: data)

    // Then
    #expect(response.suggestions.isEmpty)
}

@Test("FetchCommentsResponse alias should work correctly")
func testFetchCommentsResponseAlias() async throws {
    // Given
    let json = """
    {
        "comments": []
    }
    """
    let data = Data(json.utf8)

    // When
    let response = try JSONDecoder().decode(FetchCommentsResponse.self, from: data)

    // Then
    #expect(response.comments.isEmpty)
}
