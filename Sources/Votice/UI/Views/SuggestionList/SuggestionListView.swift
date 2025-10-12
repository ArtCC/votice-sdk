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
        tvOSView
#else
        standardView
#endif
    }
}

// MARK: - Private
// MARK: - Standard Platforms (iOS, iPadOS, macOS)

private extension SuggestionListView {
    var standardView: some View {
        ZStack {
            LinearGradient(
                colors: [
                    theme.colors.background,
                    theme.colors.background.opacity(0.95)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.all)
            if viewModel.isLoading && viewModel.currentSuggestionsList.isEmpty {
                LoadingView(message: TextManager.shared.texts.loadingSuggestions)
            } else {
                VStack(spacing: 0) {
                    headerView
                    if viewModel.showCompletedSeparately {
                        if viewModel.liquidGlassEnabled {
#if os(iOS)
                            tabView
#else
                            segmentedControl
                            standardContentView
#endif
                        } else {
                            segmentedControl
                            standardContentView
                        }
                    } else {
                        standardContentView
                    }
                }
                floatingActionButton
            }
        }
        .navigationBarBackButtonHidden()
        .task {
            await viewModel.loadSuggestions()
        }
        .voticeAlert(
            isPresented: $viewModel.isShowingAlert,
            alert: viewModel.currentAlert ?? VoticeAlertEntity.error(message: TextManager.shared.texts.genericError)
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
    }

    var headerView: some View {
        HStack {
            CloseButton(isNavigation: isNavigation) {
                presentationMode.wrappedValue.dismiss()
            }
            Spacer()
            Text(TextManager.shared.texts.featureRequests)
                .font(theme.typography.title3)
                .fontWeight(.regular)
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

    var segmentedControl: some View {
        SegmentedControl(
            selection: $viewModel.selectedTab,
            segments: [
                .init(id: 0, title: TextManager.shared.texts.activeTab),
                .init(id: 1, title: TextManager.shared.texts.completedTab)
            ]
        )
        .transition(.opacity.combined(with: .move(edge: .top)))
        .animation(.easeInOut, value: viewModel.selectedTab)
    }

    var tabView: some View {
        TabView(selection: $viewModel.selectedTab) {
            VStack {
                standardContentView
            }
            .tabItem {
                Label(TextManager.shared.texts.activeTab, systemImage: "list.bullet")
            }
            .tag(0)
            VStack {
                standardContentView
            }
            .tabItem {
                Label(TextManager.shared.texts.completedTab, systemImage: "checkmark.circle")
            }
            .tag(1)
        }
    }

    @ViewBuilder
    var standardContentView: some View {
        if viewModel.currentSuggestionsList.isEmpty && !viewModel.isLoading {
            EmptyStateView(
                title: TextManager.shared.texts.noSuggestionsYet,
                message: TextManager.shared.texts.beFirstToSuggest
            )
        } else {
            suggestionsList
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
                    LoadingPaginationView()
                }
                Spacer()
                    .frame(height: viewModel.liquidGlassEnabled ? 10 : 30)
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
        VStack {
            Spacer()
            HStack {
                Spacer()
                Button {
                    HapticManager.shared.lightImpact()

                    viewModel.presentCreateSuggestionSheet()
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .adaptiveCircularGlassBackground(
                            useLiquidGlass: viewModel.liquidGlassEnabled,
                            fillColor: theme.colors.primary,
                            shadowColor: .black.opacity(0.1),
                            shadowRadius: 2,
                            shadowX: 0,
                            shadowY: 1,
                            isInteractive: true
                        )
                }
                .scaleEffect(showCreateButton ? 1.0 : 0.9)
                .opacity(showCreateButton ? 1.0 : 0.7)
                .animation(.spring(response: 0.5, dampingFraction: 0.8), value: showCreateButton)
                .buttonStyle(.plain)
            }
            .padding(.trailing, theme.spacing.md)
            .padding(.bottom, hasNotchOrDynamicIsland ? -10 : theme.spacing.lg)
        }
    }
}

// MARK: - tvOS

#if os(tvOS)
private extension SuggestionListView {
    var tvOSView: some View {
        VStack(spacing: 10) {
            if viewModel.isLoading && viewModel.currentSuggestionsList.isEmpty {
                LoadingView(message: TextManager.shared.texts.loadingSuggestions)
            } else {
                tvOSHeaderView
                if viewModel.showCompletedSeparately {
                    tvOSSegmentedControl
                }
                if viewModel.currentSuggestionsList.isEmpty && !viewModel.isLoading {
                    EmptyStateView(
                        title: TextManager.shared.texts.noSuggestionsYet,
                        message: TextManager.shared.texts.beFirstToSuggest
                    )
                } else {
                    tvOSSuggestionsList
                }
            }
        }
        .task {
            await viewModel.loadSuggestions()
        }
        .voticeAlert(
            isPresented: $viewModel.isShowingAlert,
            alert: viewModel.currentAlert ?? VoticeAlertEntity.error(message: TextManager.shared.texts.genericError)
        )
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

    var tvOSHeaderView: some View {
        HStack {
            Text(TextManager.shared.texts.featureRequests)
                .font(theme.typography.title3)
                .fontWeight(.regular)
                .foregroundColor(theme.colors.onBackground)
            Spacer()
        }
        .padding(.vertical, theme.spacing.md)
        .padding(.horizontal, theme.spacing.llg)
        .zIndex(1)
    }

    var tvOSSegmentedControl: some View {
        SegmentedControl(
            selection: $viewModel.selectedTab,
            segments: [
                .init(id: 0, title: TextManager.shared.texts.activeTab),
                .init(id: 1, title: TextManager.shared.texts.completedTab)
            ]
        )
        .transition(.opacity.combined(with: .move(edge: .top)))
    }

    var tvOSSuggestionsList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 20) {
                ForEach(Array(viewModel.currentSuggestionsList.enumerated()), id: \.element.id) { index, suggestion in
                    Button {
                        // viewModel.selectSuggestion(suggestion)
                    } label: {
                        TVOSSuggestionCard(
                            suggestion: suggestion,
                            currentVote: viewModel.getCurrentVote(for: suggestion.id)
                        )
                    }
                    .buttonStyle(.card)
                    .padding(.top, index == 0 ? 30 : 0)
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
                    LoadingPaginationView()
                }
                Spacer()
                    .frame(height: 30)
            }
            .padding(.horizontal, theme.spacing.llg)
        }
    }
}
#endif
