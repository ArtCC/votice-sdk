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

    @State private var showCreateButton = true

    // MARK: - View

    var body: some View {
        NavigationView {
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
                        floatingActionButton
                    }
                    .padding(.trailing, theme.spacing.lg)
                    .padding(.bottom, theme.spacing.lg)
                }
            }
            .navigationTitle(TextManager.shared.texts.featureRequests)
#if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    filterMenu
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
        .voticeAlert(
            isPresented: $viewModel.alertManager.isShowingAlert,
            alert: viewModel.alertManager.currentAlert ?? VoticeAlertEntity.error(message: "Unknown error")
        )
    }
}

// MARK: - Private

private extension SuggestionListView {
    var suggestionsList: some View {
        ScrollView {
            LazyVStack(spacing: theme.spacing.lg) {
                ForEach(Array(viewModel.suggestions.enumerated()), id: \.element.id) { index, suggestion in
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
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                        Text(TextManager.shared.texts.loadingMore)
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.secondary)
                    }
                    .padding(theme.spacing.lg)
                }
                Spacer()
                    .frame(height: 80)
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.top, theme.spacing.md)
        }
    }

    var floatingActionButton: some View {
        Button {
            HapticManager.shared.lightImpact()

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
        .scaleEffect(showCreateButton ? 1.0 : 0.9)
        .opacity(showCreateButton ? 1.0 : 0.7)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showCreateButton)
    }

    var filterMenu: some View {
        Menu {
            filterButton(title: TextManager.shared.texts.all, filter: nil)
            filterButton(title: TextManager.shared.texts.pending, filter: .pending)
            filterButton(title: TextManager.shared.texts.accepted, filter: .accepted)
            filterButton(title: TextManager.shared.texts.inProgress, filter: .inProgress)
            filterButton(title: TextManager.shared.texts.rejected, filter: .rejected)
            filterButton(title: TextManager.shared.texts.completed, filter: .completed)
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .foregroundColor(theme.colors.primary)
                if viewModel.selectedFilter != nil {
                    Circle()
                        .fill(theme.colors.accent)
                        .frame(width: 8, height: 8)
                }
            }
        }
    }

    func filterButton(title: String, filter: SuggestionStatusEntity?) -> some View {
        Button {
            viewModel.setFilter(filter)
        } label: {
            HStack {
                Text(title)
                Spacer()
                if viewModel.selectedFilter == filter {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.colors.primary)
                }
            }
        }
    }
}
