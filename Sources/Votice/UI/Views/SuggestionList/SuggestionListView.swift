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
                    LoadingView(message: ConfigurationManager.Texts.loadingSuggestions)
                } else if viewModel.suggestions.isEmpty && !viewModel.isLoading {
                    EmptyStateView(
                        title: ConfigurationManager.Texts.noSuggestionsYet,
                        message: ConfigurationManager.Texts.beFirstToSuggest
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
            .navigationTitle(ConfigurationManager.Texts.featureRequests)
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Menu {
                        FilterButton(title: ConfigurationManager.Texts.all,
                                     isSelected: viewModel.selectedFilter == nil,
                                     action: { viewModel.setFilter(nil) })
                        FilterButton(title: ConfigurationManager.Texts.pending,
                                     isSelected: viewModel.selectedFilter == .pending,
                                     action: { viewModel.setFilter(.pending) })
                        FilterButton(title: ConfigurationManager.Texts.accepted,
                                     isSelected: viewModel.selectedFilter == .accepted,
                                     action: { viewModel.setFilter(.accepted) })
                        FilterButton(title: ConfigurationManager.Texts.inProgress,
                                     isSelected: viewModel.selectedFilter == .inProgress,
                                     action: { viewModel.setFilter(.inProgress) })
                        FilterButton(title: ConfigurationManager.Texts.completed,
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
        .alert(ConfigurationManager.Texts.error, isPresented: $viewModel.showingError) {
            Button(ConfigurationManager.Texts.ok) {}
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
