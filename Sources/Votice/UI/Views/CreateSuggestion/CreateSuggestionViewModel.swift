//
//  CreateSuggestionViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

@MainActor
final class CreateSuggestionViewModel: ObservableObject {
    // MARK: - Properties

    @Published var isSubmitting = false
    @Published var title = ""
    @Published var description = ""
    @Published var nickname = ""
    @Published var currentAlert: VoticeAlertEntity?
    @Published var isShowingAlert = false

    var isFormValid: Bool {
        !title.isEmpty
    }

    private let suggestionUseCase: SuggestionUseCaseProtocol

    // MARK: - Init

    init(suggestionUseCase: SuggestionUseCaseProtocol = SuggestionUseCase()) {
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
            let user: UserEntity = ConfigurationManager.shared.user
            let response = try await suggestionUseCase.createSuggestion(
                title: title,
                description: description,
                nickname: nickname,
                userIsPremium: user.isPremium
            )

            return response.suggestion
        } catch {
            LogManager.shared.devLog(.error, "CreateSuggestionViewModel: failed to create suggestion: \(error)")

            showError()

            throw error
        }
    }

    func submitSuggestion(onSuccess: @escaping (SuggestionEntity) -> Void) async {
        do {
            let suggestion = try await createSuggestion(
                title: title,
                description: description,
                nickname: nickname.isEmpty ? nil : nickname
            )

            onSuccess(suggestion)
        } catch {
            LogManager.shared.devLog(.error, "CreateSuggestionViewModel: failed to submit suggestion: \(error)")
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
    func showAlert(_ alert: VoticeAlertEntity) {
        currentAlert = alert

        isShowingAlert = true
    }

    func showError() {
        showAlert(VoticeAlertEntity.error(message: TextManager.shared.texts.genericError))
    }
}
