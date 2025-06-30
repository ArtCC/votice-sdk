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

    // MARK: - View

    var body: some View {
        NavigationView {
            ZStack {
                theme.colors.background.ignoresSafeArea()
                if viewModel.isLoading && viewModel.suggestions.isEmpty {
                    LoadingView(message: TextManager.shared.texts.loadingSuggestions)
                } else if viewModel.suggestions.isEmpty && !viewModel.isLoading {
                    EmptyStateView(
                        title: TextManager.shared.texts.noSuggestionsYet,
                        message: TextManager.shared.texts.beFirstToSuggest
                    )
                } else {
                    suggestionsList
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            viewModel.presentCreateSuggestionSheet()
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
                    }
                }
            }
            .navigationTitle(TextManager.shared.texts.featureRequests)
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        FilterButton(title: TextManager.shared.texts.all,
                                     isSelected: viewModel.selectedFilter == nil,
                                     action: { viewModel.setFilter(nil) })
                        FilterButton(title: TextManager.shared.texts.pending,
                                     isSelected: viewModel.selectedFilter == .pending,
                                     action: { viewModel.setFilter(.pending) })
                        FilterButton(title: TextManager.shared.texts.accepted,
                                     isSelected: viewModel.selectedFilter == .accepted,
                                     action: { viewModel.setFilter(.accepted) })
                        FilterButton(title: TextManager.shared.texts.inProgress,
                                     isSelected: viewModel.selectedFilter == .inProgress,
                                     action: { viewModel.setFilter(.inProgress) })
                        FilterButton(title: TextManager.shared.texts.completed,
                                     isSelected: viewModel.selectedFilter == .completed,
                                     action: { viewModel.setFilter(.completed) })
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
            .sheet(isPresented: $viewModel.showingCreateSuggestion) {
                CreateSuggestionView { suggestion in
                    viewModel.addSuggestion(suggestion)
                }
            }
            .sheet(item: $viewModel.selectedSuggestion) { suggestion in
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
        .alert(TextManager.shared.texts.error, isPresented: $viewModel.showingError) {
            Button(TextManager.shared.texts.ok) {}
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
                ForEach(Array(viewModel.suggestions.enumerated()), id: \ .element.id) { index, suggestion in
                    SuggestionCard(
                        suggestion: suggestion,
                        currentVote: viewModel.getCurrentVote(for: suggestion.id),
                        onVote: { voteType in
                            Task {
                                await viewModel.vote(on: suggestion.id, type: voteType)
                            }
                        },
                        onTap: {
                            viewModel.selectSuggestion(suggestion)
                        }
                    )
                    .onAppear {
                        if index >= viewModel.suggestions.count - 3
                            && viewModel.hasMoreSuggestions &&
                            !viewModel.isLoading {
                            Task {
                                await viewModel.loadMoreSuggestions()
                            }
                        }
                    }
                }
                if viewModel.isLoading && viewModel.suggestions.count > 0 {
                    ProgressView()
                        .padding()
                }
            }
            .padding(theme.spacing.md)
        }
    }
}
