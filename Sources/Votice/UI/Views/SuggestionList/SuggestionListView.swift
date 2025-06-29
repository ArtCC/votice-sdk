//
//  SuggestionListView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

// MARK: - Suggestion List View

struct SuggestionListView: View {
    @Environment(\.voticeTheme) private var theme
    @StateObject private var viewModel = SuggestionListViewModel()

    @State private var showingCreateSuggestion = false
    @State private var selectedSuggestion: SuggestionEntity?

    var body: some View {
        NavigationView {
            ZStack {
                theme.colors.background.ignoresSafeArea()

                if viewModel.isLoading && viewModel.suggestions.isEmpty {
                    LoadingView()
                } else if viewModel.suggestions.isEmpty && !viewModel.isLoading {
                    EmptyStateView {
                        showingCreateSuggestion = true
                    }
                } else {
                    suggestionsList
                }
            }
            .navigationTitle("Feature Requests")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New") {
                        showingCreateSuggestion = true
                    }
                    .foregroundColor(theme.colors.primary)
                }

                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        FilterButton(
                            title: "All",
                            isSelected: viewModel.selectedFilter == nil,
                            action: { viewModel.setFilter(nil) }
                        )

                        FilterButton(
                            title: "Pending",
                            isSelected: viewModel.selectedFilter == .pending,
                            action: { viewModel.setFilter(.pending) }
                        )

                        FilterButton(
                            title: "Accepted",
                            isSelected: viewModel.selectedFilter == .accepted,
                            action: { viewModel.setFilter(.accepted) }
                        )

                        FilterButton(
                            title: "In Progress",
                            isSelected: viewModel.selectedFilter == .inProgress,
                            action: { viewModel.setFilter(.inProgress) }
                        )

                        FilterButton(
                            title: "Completed",
                            isSelected: viewModel.selectedFilter == .completed,
                            action: { viewModel.setFilter(.completed) }
                        )
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(theme.colors.primary)
                    }
                }
                #else
                ToolbarItem(placement: .primaryAction) {
                    Button("New") {
                        showingCreateSuggestion = true
                    }
                    .foregroundColor(theme.colors.primary)
                }

                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        FilterButton(
                            title: "All",
                            isSelected: viewModel.selectedFilter == nil,
                            action: { viewModel.setFilter(nil) }
                        )

                        FilterButton(
                            title: "Pending",
                            isSelected: viewModel.selectedFilter == .pending,
                            action: { viewModel.setFilter(.pending) }
                        )

                        FilterButton(
                            title: "Accepted",
                            isSelected: viewModel.selectedFilter == .accepted,
                            action: { viewModel.setFilter(.accepted) }
                        )

                        FilterButton(
                            title: "In Progress",
                            isSelected: viewModel.selectedFilter == .inProgress,
                            action: { viewModel.setFilter(.inProgress) }
                        )

                        FilterButton(
                            title: "Completed",
                            isSelected: viewModel.selectedFilter == .completed,
                            action: { viewModel.setFilter(.completed) }
                        )
                    } label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                            .foregroundColor(theme.colors.primary)
                    }
                }
                #endif
            }
            .refreshable {
                await viewModel.refresh()
            }
            .sheet(isPresented: $showingCreateSuggestion) {
                CreateSuggestionView { suggestion in
                    viewModel.addSuggestion(suggestion)
                }
            }
            .sheet(item: $selectedSuggestion) { suggestion in
                SuggestionDetailView(suggestion: suggestion) { updatedSuggestion in
                    viewModel.updateSuggestion(updatedSuggestion)
                }
            }
        }
        .task {
            await viewModel.loadSuggestions()
        }
        .alert("Error", isPresented: $viewModel.showingError) {
            Button("OK") {}
        } message: {
            Text(viewModel.errorMessage)
        }
    }

    private var suggestionsList: some View {
        ScrollView {
            LazyVStack(spacing: theme.spacing.md) {
                ForEach(viewModel.suggestions) { suggestion in
                    SuggestionCard(
                        suggestion: suggestion,
                        currentVote: viewModel.getCurrentVote(for: suggestion.id),
                        onVote: { voteType in
                            Task {
                                await viewModel.vote(on: suggestion.id, type: voteType)
                            }
                        },
                        onTap: {
                            selectedSuggestion = suggestion
                        }
                    )
                }

#warning("Hay que revisar la paginación, no funciona ni está habilitada en Firebase.")
                /**
                if viewModel.hasMoreSuggestions {
                    Button("Load More") {
                        Task {
                            await viewModel.loadMoreSuggestions()
                        }
                    }
                    .padding()
                    .foregroundColor(theme.colors.primary)
                }*/
            }
            .padding(theme.spacing.md)
        }
    }
}

// MARK: - Filter Button

private struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(title)
                if isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

// MARK: - Loading View

private struct LoadingView: View {
    @Environment(\.voticeTheme) private var theme

    var body: some View {
        VStack(spacing: theme.spacing.md) {
            ProgressView()
                .scaleEffect(1.2)

            Text("Loading suggestions...")
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }
}

// MARK: - Empty State View

private struct EmptyStateView: View {
    @Environment(\.voticeTheme) private var theme
    let onCreateSuggestion: () -> Void

    var body: some View {
        VStack(spacing: theme.spacing.lg) {
            Image(systemName: "lightbulb")
                .font(.system(size: 64))
                .foregroundColor(theme.colors.secondary)

            VStack(spacing: theme.spacing.sm) {
                Text("No suggestions yet")
                    .font(theme.typography.title2)
                    .foregroundColor(theme.colors.onBackground)

                Text("Be the first to suggest a new feature!")
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .multilineTextAlignment(.center)
            }

            Button("Create Suggestion") {
                onCreateSuggestion()
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(theme.colors.primary)
            .foregroundColor(.white)
            .cornerRadius(theme.cornerRadius.md)
        }
        .padding(theme.spacing.xl)
    }
}
