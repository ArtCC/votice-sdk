//
//  SuggestionRepositoryProtocol.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol SuggestionRepositoryProtocol: Sendable {
    func createSuggestion(request: CreateSuggestionRequest) async throws -> CreateSuggestionResponse
    func fetchSuggestions(request: FetchSuggestionsRequest) async throws -> FetchSuggestionsResponse
    func voteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse
    func unvoteSuggestion(request: VoteSuggestionRequest) async throws -> VoteSuggestionResponse
}
