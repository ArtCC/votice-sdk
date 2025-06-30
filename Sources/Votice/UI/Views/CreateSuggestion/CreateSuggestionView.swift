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

    @FocusState private var focusedField: Field?

    private enum Field {
        case title, description, nickname
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
                            await viewModel.submitSuggestion { suggestion in
                                onSuggestionCreated(suggestion)

                                dismiss()
                            }
                        }
                    }
                    .foregroundColor(viewModel.isFormValid ? theme.colors.primary : theme.colors.secondary)
                    .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
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
                TextField("Enter a brief title for your suggestion", text: $viewModel.title)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .title)
                Text("Keep it short and descriptive")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text("Description (Optional)")
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField("Describe your suggestion in detail...", text: $viewModel.description, axis: .vertical)
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
                TextField("Enter your name", text: $viewModel.nickname)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .nickname)
                Text("Leave empty to submit anonymously")
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}
