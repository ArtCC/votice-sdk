//
//  CreateSuggestionView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Create Suggestion View

struct CreateSuggestionView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.voticeTheme) private var theme

    let onSuggestionCreated: (SuggestionEntity) -> Void

    @StateObject private var viewModel = CreateSuggestionViewModel()

    @State private var title = ""
    @State private var description = ""
    @State private var nickname = ""

    @FocusState private var focusedField: Field?

    private enum Field {
        case title, description, nickname
    }

    private var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationView {
            ZStack {
                theme.colors.background.ignoresSafeArea()

                ScrollView {
                    VStack(alignment: .leading, spacing: theme.spacing.lg) {
                        headerSection

                        formSection

                        Spacer(minLength: theme.spacing.xl)
                    }
                    .padding(theme.spacing.md)
                }
            }
            .navigationTitle("New Suggestion")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Submit") {
                        Task {
                            await submitSuggestion()
                        }
                    }
                    .foregroundColor(isFormValid ? theme.colors.primary : theme.colors.secondary)
                    .disabled(!isFormValid || viewModel.isSubmitting)
                }
                #else
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Submit") {
                        Task {
                            await submitSuggestion()
                        }
                    }
                    .foregroundColor(isFormValid ? theme.colors.primary : theme.colors.secondary)
                    .disabled(!isFormValid || viewModel.isSubmitting)
                }
                #endif
            }
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Share your idea")
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)

            Text("Help us improve by suggesting new features or improvements.")
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }

    private var formSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            // Title Field
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Title")
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)

                TextField("Enter a brief title for your suggestion", text: $title)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .title)

                Text("Keep it short and descriptive")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }

            // Description Field
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Description")
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)

                TextField("Describe your suggestion in detail...", text: $description, axis: .vertical)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .lineLimit(5...10)
                    .focused($focusedField, equals: .description)

                Text("Explain why this feature would be useful")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }

            // Optional Nickname Field
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Your Name (Optional)")
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)

                TextField("Enter your name", text: $nickname)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .nickname)

                Text("Leave empty to submit anonymously")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    private func submitSuggestion() async {
        let trimmedNickname = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            let suggestion = try await viewModel.createSuggestion(
                title: title,
                description: description,
                nickname: trimmedNickname.isEmpty ? nil : trimmedNickname
            )

            onSuggestionCreated(suggestion)
            dismiss()
        } catch {
            // Error is handled by the ViewModel
        }
    }
}

// MARK: - Votice Text Field Style

private struct VoticeTextFieldStyle: TextFieldStyle {
    @Environment(\.voticeTheme) private var theme

    // swiftlint:disable identifier_name
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(theme.spacing.md)
            .background(theme.colors.surface)
            .cornerRadius(theme.cornerRadius.md)
            .overlay(
                RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                    .stroke(theme.colors.secondary.opacity(0.3), lineWidth: 1)
            )
    }
    // swiftlint:enable identifier_name
}

// MARK: - Create Suggestion View Model

@MainActor
final class CreateSuggestionViewModel: ObservableObject {
    @Published var isSubmitting = false
    @Published var showingError = false
    @Published var errorMessage = ""

    private let createSuggestionUseCase: CreateSuggestionUseCase

    init(createSuggestionUseCase: CreateSuggestionUseCase = CreateSuggestionUseCase()) {
        self.createSuggestionUseCase = createSuggestionUseCase
    }

    func createSuggestion(title: String, description: String, nickname: String?) async throws -> SuggestionEntity {
        guard !isSubmitting else { throw VoticeError.invalidInput("Already submitting") }

        isSubmitting = true
        defer { isSubmitting = false }

        do {
            let response = try await createSuggestionUseCase.execute(
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
