//
//  CreateSuggestionViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

@MainActor
final class CreateSuggestionViewModel: ObservableObject {
    // MARK: - Properties

    @Published var isSubmitting = false
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var title = ""
    @Published var description = ""
    @Published var nickname = ""

    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private let suggestionUseCase: SuggestionUseCase

    // MARK: - Init

    init(suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.suggestionUseCase = suggestionUseCase
    }

    // MARK: - Functions

    func createSuggestion(title: String, description: String?, nickname: String?) async throws -> SuggestionEntity {
        guard !isSubmitting else {
            throw VoticeError.invalidInput("Already submitting")
        }

        isSubmitting = true

        defer {
            isSubmitting = false
        }

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

    func submitSuggestion(onSuccess: @escaping (SuggestionEntity) -> Void) async {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let suggestion = try await createSuggestion(title: title,
                                                        description: description,
                                                        nickname: trimmedNickname.isEmpty ? nil : trimmedNickname)

            onSuccess(suggestion)
        } catch {
            LogManager.shared.devLog(.error, "Failed to create suggestion: \(error)")
        }
    }

    func resetForm() {
        title = ""
        description = ""
        nickname = ""
    }
}

// MARK: - Private

private extension CreateSuggestionViewModel {
    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription

        showingError = true

        LogManager.shared.devLog(.error, "CreateSuggestionViewModel error: \(error)")
    }
}
