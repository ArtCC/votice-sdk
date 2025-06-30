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
            .navigationTitle(ConfigurationManager.currentTexts.newSuggestion)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(ConfigurationManager.currentTexts.cancel) {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(ConfigurationManager.currentTexts.submit) {
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
        .alert(ConfigurationManager.currentTexts.error, isPresented: $viewModel.showingError) {
            Button(ConfigurationManager.currentTexts.ok) {}
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
            Text(ConfigurationManager.currentTexts.shareYourIdea)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
            Text(ConfigurationManager.currentTexts.helpUsImprove)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }

    var formSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(ConfigurationManager.currentTexts.title)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(ConfigurationManager.currentTexts.titlePlaceholder, text: $viewModel.title)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .title)
                Text(ConfigurationManager.currentTexts.keepItShort)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(ConfigurationManager.currentTexts.descriptionOptional)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(
                    ConfigurationManager.currentTexts.descriptionPlaceholder,
                    text: $viewModel.description,
                    axis: .vertical
                )
                .textFieldStyle(VoticeTextFieldStyle())
                .lineLimit(5...10)
                .focused($focusedField, equals: .description)
                Text(ConfigurationManager.currentTexts.explainWhyUseful)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(ConfigurationManager.currentTexts.yourNameOptionalCreate)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(ConfigurationManager.currentTexts.enterYourNameCreate, text: $viewModel.nickname)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .nickname)
                Text(ConfigurationManager.currentTexts.leaveEmptyAnonymous)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}
