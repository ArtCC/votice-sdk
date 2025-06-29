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

    func createSuggestion(title: String, description: String, nickname: String?) async throws -> SuggestionEntity {
        guard !isSubmitting else { throw VoticeError.invalidInput("Already submitting") }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let response = try await suggestionUseCase.createSuggestion(
                title: title,
                description: description,
                nickname: nickname
            )

            // Create a temporary SuggestionEntity for the UI
            // In a real scenario, we'd get this from the backend response
            let suggestion = SuggestionEntity(
                id: response.id,
                appId: ConfigurationManager.shared.appId, // This would come from configuration
                title: title,
                text: nil,
                description: description,
                nickname: nickname,
                createdAt: Date().ISO8601Format(),
                updatedAt: Date().ISO8601Format(),
                platform: DeviceManager.shared.platform,
                createdBy: DeviceManager.shared.deviceId,
                status: .pending,
                source: .sdk,
                commentCount: 0,
                voteCount: 0
            )

            return suggestion
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
