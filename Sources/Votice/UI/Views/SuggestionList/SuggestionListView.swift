//
//  SuggestionListView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct SuggestionListView: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @StateObject private var viewModel = SuggestionListViewModel()

    @State private var showingCreateSuggestion = false
    @State private var selectedSuggestion: SuggestionEntity?

    // MARK: - View

    var body: some View {
        NavigationView {
            ZStack {
                theme.colors.background.ignoresSafeArea()
                if viewModel.isLoading && viewModel.suggestions.isEmpty {
                    LoadingView()
                } else if viewModel.suggestions.isEmpty && !viewModel.isLoading {
                    EmptyStateView()
                } else {
                    suggestionsList
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            showingCreateSuggestion = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .padding()
                                .background(theme.colors.primary)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        .padding()
                        .accessibilityLabel("Create new suggestion")
                    }
                }
            }
            .navigationTitle("Feature Requests")
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
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
            }
#endif
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
                } onReload: {
                    Task {
                        await viewModel.loadSuggestions()
                    }
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
}

// MARK: - Private

private extension SuggestionListView {
    // MARK: - Properties

    var suggestionsList: some View {
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
