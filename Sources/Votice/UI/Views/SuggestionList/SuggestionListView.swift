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

    @Environment(\.presentationMode) private var presentationMode
    @Environment(\.voticeTheme) private var theme

    @StateObject private var viewModel = SuggestionListViewModel()

    @State private var showCreateButton = true

    let isNavigation: Bool

    // MARK: - View

    var body: some View {
#if os(tvOS)
        VStack {
            Spacer()
            Text("Votice SDK is not available on tvOS. Soon you will be able to view your suggestions here.")
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
                .padding()
            Spacer()
        }
#else
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
            if viewModel.isLoading && viewModel.currentSuggestionsList.isEmpty {
                LoadingView(message: TextManager.shared.texts.loadingSuggestions)
            } else {
                VStack(spacing: 0) {
                    headerView
                    if viewModel.showCompletedSeparately {
                        segmentedControl
                    }
                    if viewModel.currentSuggestionsList.isEmpty && !viewModel.isLoading {
                        EmptyStateView(
                            title: TextManager.shared.texts.noSuggestionsYet,
                            message: TextManager.shared.texts.beFirstToSuggest
                        )
                    } else {
                        suggestionsList
                    }
                }
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        floatingActionButton
                    }
                    .padding(.trailing, theme.spacing.md)
                    .padding(.bottom, theme.spacing.md)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.loadSuggestions()
        }
        .voticeAlert(
            isPresented: $viewModel.isShowingAlert,
            alert: viewModel.currentAlert ?? VoticeAlertEntity.error(message: "Unknown error")
        )
        .sheet(isPresented: $viewModel.showingCreateSuggestion) {
            CreateSuggestionView { suggestion in
                viewModel.addSuggestion(suggestion)
            }
#if os(macOS)
            .frame(minWidth: 800, minHeight: 600)
#endif
        }
        .sheet(item: $viewModel.selectedSuggestion) { suggestion in
            SuggestionDetailView(suggestion: suggestion) { updatedSuggestion in
                viewModel.updateSuggestion(updatedSuggestion)
            } onReload: {
                Task {
                    await viewModel.loadSuggestions()
                }
            }
#if os(macOS)
            .frame(minWidth: 800, minHeight: 600)
#endif
        }
#endif
    }
}

// MARK: - Private

private extension SuggestionListView {
    var headerView: some View {
        HStack {
            CloseButton(isNavigation: isNavigation) {
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
            Text(TextManager.shared.texts.featureRequests)
                .font(theme.typography.title2)
                .fontWeight(.medium)
                .foregroundColor(theme.colors.onBackground)
            Spacer()
            filterMenuButton
        }
        .padding(theme.spacing.md)
        .background(
            theme.colors.background
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .zIndex(1)
    }

    var filterMenuButton: some View {
        FilterMenuView(
            isExpanded: $viewModel.isFilterMenuExpanded,
            selectedFilter: viewModel.selectedFilter
        ) { filter in
            viewModel.setFilter(filter)
        }
    }

    var suggestionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: theme.spacing.md) {
                ForEach(Array(viewModel.currentSuggestionsList.enumerated()), id: \.element.id) { index, suggestion in
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
                        if index >= viewModel.currentSuggestionsList.count - 3
                            && viewModel.hasMoreSuggestions &&
                            !viewModel.isLoadingPagination {
                            Task {
                                await viewModel.loadMoreSuggestions()
                            }
                        }
                    }
                }
                if viewModel.isLoadingPagination && viewModel.currentSuggestionsList.count > 0 {
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                        Text(TextManager.shared.texts.loadingMore)
                            .font(theme.typography.caption)
                            .foregroundColor(theme.colors.secondary)
                    }
                    .padding(theme.spacing.md)
                }
                Spacer()
                    .frame(height: 80)
            }
            .padding(.top, theme.spacing.md)
            .padding(.horizontal, theme.spacing.md)
        }
        .scrollBounceBehavior(.basedOnSize)
        .scrollDismissesKeyboard(.immediately)
        .refreshable {
            await viewModel.refresh()
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
        .buttonStyle(.plain)
    }

    var segmentedControl: some View {
        CustomSegmentedControl(
            selection: $viewModel.selectedTab,
            segments: [
                .init(id: 0, title: TextManager.shared.texts.activeTab),
                .init(id: 1, title: TextManager.shared.texts.completedTab)
            ]
        )
        .transition(.opacity.combined(with: .move(edge: .top)))
    }
}
