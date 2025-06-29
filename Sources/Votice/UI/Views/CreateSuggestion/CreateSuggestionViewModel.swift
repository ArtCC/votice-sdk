//
//  CreateSuggestionViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Create Suggestion View Model

@MainActor
final class CreateSuggestionViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var showingError = false
    @Published var errorMessage = ""

    private let suggestionUseCase: SuggestionUseCase

    init(suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.suggestionUseCase = suggestionUseCase
    }

    func createSuggestion(title: String, description: String?, nickname: String?) async throws -> SuggestionEntity {
        guard !isSubmitting else { throw VoticeError.invalidInput("Already submitting") }

        isSubmitting = true

        defer { isSubmitting = false }

        do {
            let response = try await suggestionUseCase.createSuggestion(title: title,
                                                                        description: description,
                                                                        nickname: nickname)

            return response.suggestion
        } catch {
            handleError(error)

            throw error
        }
    }

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
        LogManager.shared.devLog(.error, "CreateSuggestionViewModel error: \(error)")
    }
}
