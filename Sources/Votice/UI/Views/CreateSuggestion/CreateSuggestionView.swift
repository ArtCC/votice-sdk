//
//  CreateSuggestionView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct CreateSuggestionView: View {
    // MARK: - Properties

    @Environment(\.dismiss) private var dismiss
    @Environment(\.voticeTheme) private var theme

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

    let onSuggestionCreated: (SuggestionEntity) -> Void

    // MARK: - View

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
            .toolbar {
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
            }
#endif
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }
}

// MARK: - Private

private extension CreateSuggestionView {
    // MARK: - Properties

    var headerSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            Text("Share your idea")
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
            Text("Help us improve by suggesting new features or improvements.")
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }

    var formSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
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

    // MARK: - Functions

    func submitSuggestion() async {
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
            LogManager.shared.devLog(.error, "Failed to create suggestion: \(error)")
        }
    }
}
