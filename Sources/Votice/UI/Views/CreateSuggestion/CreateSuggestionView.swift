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
            .navigationTitle(TextManager.shared.texts.newSuggestion)
#if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(TextManager.shared.texts.cancel) {
                        dismiss()
                    }
                    .foregroundColor(theme.colors.secondary)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(TextManager.shared.texts.submit) {
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
        .alert(TextManager.shared.texts.error, isPresented: $viewModel.showingError) {
            Button(TextManager.shared.texts.ok) {}
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
            Text(TextManager.shared.texts.shareYourIdea)
                .font(theme.typography.title2)
                .foregroundColor(theme.colors.onBackground)
            Text(TextManager.shared.texts.helpUsImprove)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }

    var formSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.lg) {
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(TextManager.shared.texts.title)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(TextManager.shared.texts.titlePlaceholder, text: $viewModel.title)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .title)
                Text(TextManager.shared.texts.keepItShort)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(TextManager.shared.texts.descriptionOptional)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(
                    TextManager.shared.texts.descriptionPlaceholder,
                    text: $viewModel.description,
                    axis: .vertical
                )
                .textFieldStyle(VoticeTextFieldStyle())
                .lineLimit(5...10)
                .focused($focusedField, equals: .description)
                Text(TextManager.shared.texts.explainWhyUseful)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
            VStack(alignment: .leading, spacing: theme.spacing.sm) {
                Text(TextManager.shared.texts.yourNameOptionalCreate)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                TextField(TextManager.shared.texts.enterYourNameCreate, text: $viewModel.nickname)
                    .textFieldStyle(VoticeTextFieldStyle())
                    .focused($focusedField, equals: .nickname)
                Text(TextManager.shared.texts.leaveEmptyAnonymous)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}
