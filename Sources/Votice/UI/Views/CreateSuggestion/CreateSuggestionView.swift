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
        ZStack {
            LinearGradient(
                colors: [
                    theme.colors.background,
                    theme.colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            if viewModel.isSubmitting {
                LoadingView(message: TextManager.shared.texts.submit)
            } else {
                VStack(spacing: 0) {
                    headerView
                    mainContent
                }
            }
        }
        .voticeAlert(
            isPresented: $viewModel.isShowingAlert,
            alert: viewModel.currentAlert ?? VoticeAlertEntity.error(message: "Unknown error")
        )
    }
}

// MARK: - Private

private extension CreateSuggestionView {
    var headerView: some View {
        ZStack {
            HStack {
                Button(TextManager.shared.texts.cancel) {
                    dismiss()
                }
                .font(theme.typography.callout)
                .fontWeight(.medium)
                .foregroundColor(theme.colors.secondary)
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                        .fill(theme.colors.secondary.opacity(0.1))
                )
                .buttonStyle(PlainButtonStyle())
                Spacer()
                Button(TextManager.shared.texts.submit) {
                    HapticManager.shared.mediumImpact()

                    Task {
                        await viewModel.submitSuggestion { suggestion in
                            HapticManager.shared.success()

                            onSuggestionCreated(suggestion)

                            dismiss()
                        }
                    }
                }
                .font(theme.typography.callout)
                .fontWeight(.semibold)
                .foregroundColor(
                    viewModel.isFormValid && !viewModel.isSubmitting ? .white : theme.colors.secondary
                )
                .padding(.horizontal, theme.spacing.md)
                .padding(.vertical, theme.spacing.xs)
                .background(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                        .fill(
                            viewModel.isFormValid && !viewModel.isSubmitting
                            ? theme.colors.primary
                            : theme.colors.secondary.opacity(0.1)
                        )
                )
                .disabled(!viewModel.isFormValid || viewModel.isSubmitting)
                .buttonStyle(PlainButtonStyle())
            }
            HStack {
                Spacer()
                Text(TextManager.shared.texts.newSuggestion)
                    .font(theme.typography.headline)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.onBackground)
                Spacer()
            }
        }
        .padding(.horizontal, theme.spacing.lg)
        .padding(.vertical, theme.spacing.md)
        .background(
            theme.colors.background
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }

    var mainContent: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: theme.spacing.xl) {
                headerCard
                formCard
                Spacer(minLength: theme.spacing.xl)
            }
            .padding(theme.spacing.lg)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
    }

    var headerCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.md) {
            HStack {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    theme.colors.primary.opacity(0.2),
                                    theme.colors.accent.opacity(0.1)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    Image(systemName: "lightbulb.fill")
                        .font(.system(size: 24))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.colors.primary, theme.colors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(TextManager.shared.texts.shareYourIdea)
                        .font(theme.typography.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(theme.colors.onSurface)
                    Text(TextManager.shared.texts.helpUsImprove)
                        .font(theme.typography.body)
                        .foregroundColor(theme.colors.secondary)
                }

                Spacer()
            }
        }
        .padding(theme.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    var formCard: some View {
        VStack(alignment: .leading, spacing: theme.spacing.xl) {
            titleSection
            descriptionSection
            nicknameSection
        }
        .padding(theme.spacing.lg)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }

    var titleSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(theme.colors.primary)
                    .font(.headline)
                Text(TextManager.shared.texts.title)
                    .font(theme.typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onSurface)
            }
            TextField(TextManager.shared.texts.titlePlaceholder, text: $viewModel.title)
                .textFieldStyle(VoticeTextFieldStyle())
                .focused($focusedField, equals: .title)
                .onAppear {
                    focusedField = .title
                }
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(theme.colors.secondary)
                    .font(.caption)
                Text(TextManager.shared.texts.keepItShort)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Image(systemName: "text.alignleft")
                    .foregroundColor(theme.colors.accent)
                    .font(.headline)
                Text(TextManager.shared.texts.descriptionOptional)
                    .font(theme.typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
                Text(TextManager.shared.texts.optional)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xs)
                    .background(theme.colors.secondary.opacity(0.1))
                    .cornerRadius(theme.cornerRadius.sm)
            }
            TextField(
                TextManager.shared.texts.descriptionPlaceholder,
                text: $viewModel.description,
                axis: .vertical
            )
            .textFieldStyle(VoticeTextFieldStyle())
            .lineLimit(3...8)
            .focused($focusedField, equals: .description)
            HStack {
                Image(systemName: "info.circle")
                    .foregroundColor(theme.colors.secondary)
                    .font(.caption)
                Text(TextManager.shared.texts.explainWhyUseful)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }

    var nicknameSection: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Image(systemName: "person.circle")
                    .foregroundColor(theme.colors.secondary)
                    .font(.headline)
                Text(TextManager.shared.texts.yourNameOptionalCreate)
                    .font(theme.typography.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
                Text(TextManager.shared.texts.optional)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary.opacity(0.7))
                    .padding(.horizontal, theme.spacing.sm)
                    .padding(.vertical, theme.spacing.xs)
                    .background(theme.colors.secondary.opacity(0.1))
                    .cornerRadius(theme.cornerRadius.sm)
            }
            TextField(TextManager.shared.texts.enterYourNameCreate, text: $viewModel.nickname)
                .textFieldStyle(VoticeTextFieldStyle())
                .focused($focusedField, equals: .nickname)
            HStack {
                Image(systemName: "eye.slash")
                    .foregroundColor(theme.colors.secondary)
                    .font(.caption)
                Text(TextManager.shared.texts.leaveEmptyAnonymous)
                    .font(theme.typography.caption)
                    .foregroundColor(theme.colors.secondary)
            }
        }
    }
}
