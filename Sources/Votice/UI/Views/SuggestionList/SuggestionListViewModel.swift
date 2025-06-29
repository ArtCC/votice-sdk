//
//  SuggestionListViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import Combine

// MARK: - Suggestion List View Model

@MainActor
final class SuggestionListViewModel: ObservableObject {
    @Published var suggestions: [SuggestionEntity] = []
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var selectedFilter: SuggestionStatusEntity?
    @Published var hasMoreSuggestions = true

    private var allSuggestions: [SuggestionEntity] = []
    private var currentVotes: [String: VoteType] = [:]
    private var currentOffset = 0
    private let pageSize = 20
    private var loadingTask: Task<Void, Never>?

    // Use Cases
    private let fetchSuggestionsUseCase: FetchSuggestionsUseCase
    private let voteSuggestionUseCase: VoteSuggestionUseCase

    init(
        fetchSuggestionsUseCase: FetchSuggestionsUseCase = FetchSuggestionsUseCase(),
        voteSuggestionUseCase: VoteSuggestionUseCase = VoteSuggestionUseCase()
    ) {
        self.fetchSuggestionsUseCase = fetchSuggestionsUseCase
        self.voteSuggestionUseCase = voteSuggestionUseCase
    }

    // MARK: - Public Methods

    func loadSuggestions() async {
        // Cancel any existing loading task
        loadingTask?.cancel()

        loadingTask = Task { @MainActor in
            guard !isLoading else { return }

            isLoading = true
            currentOffset = 0
            hasMoreSuggestions = true

            do {
                let response = try await fetchSuggestionsUseCase.execute()

                // Check if task was cancelled
                guard !Task.isCancelled else {
                    isLoading = false
                    return
                }

                allSuggestions = response.suggestions
                applyFilter()
                currentOffset = response.suggestions.count
                hasMoreSuggestions = response.suggestions.count == pageSize
            } catch {
                guard !Task.isCancelled else {
                    isLoading = false
                    return
                }
                handleError(error)
            }

            isLoading = false
        }

        await loadingTask?.value
    }

    func loadMoreSuggestions() async {
        guard !isLoading && hasMoreSuggestions else { return }

        isLoading = true

        do {
            let response = try await fetchSuggestionsUseCase.execute()

            // Check if task was cancelled
            guard !Task.isCancelled else {
                isLoading = false
                return
            }

            allSuggestions.append(contentsOf: response.suggestions)
            applyFilter()
            currentOffset += response.suggestions.count
            hasMoreSuggestions = response.suggestions.count == pageSize
        } catch {
            guard !Task.isCancelled else {
                isLoading = false
                return
            }
            handleError(error)
        }

        isLoading = false
    }

    func refresh() async {
        await loadSuggestions()
    }

    func setFilter(_ status: SuggestionStatusEntity?) {
        selectedFilter = status
        applyFilter()
    }

    func vote(on suggestionId: String, type: VoteType) async {
        do {
            let response = try await voteSuggestionUseCase.execute(suggestionId: suggestionId, voteType: type)

            // Update local vote state based on response
            if let vote = response.vote {
                // Vote was registered successfully
                currentVotes[suggestionId] = type
            } else {
                // Vote was removed or not registered
                currentVotes.removeValue(forKey: suggestionId)
            }

            // Update suggestion with real data from backend
            if let updatedSuggestion = response.suggestion,
               let index = allSuggestions.firstIndex(where: { $0.id == suggestionId }) {

                let originalSuggestion = allSuggestions[index]
                let newSuggestion = SuggestionEntity(
                    id: originalSuggestion.id,
                    appId: originalSuggestion.appId,
                    title: originalSuggestion.title,
                    text: originalSuggestion.text,
                    description: originalSuggestion.description,
                    nickname: originalSuggestion.nickname,
                    createdAt: originalSuggestion.createdAt,
                    updatedAt: updatedSuggestion.updatedAt, // Use updated date from backend
                    platform: originalSuggestion.platform,
                    createdBy: originalSuggestion.createdBy,
                    status: originalSuggestion.status,
                    source: originalSuggestion.source,
                    commentCount: originalSuggestion.commentCount,
                    voteCount: updatedSuggestion.voteCount // Use real vote count from backend
                )

                // Update in allSuggestions
                allSuggestions[index] = newSuggestion

                // Reapply filter to update displayed suggestions
                applyFilter()
            }
        } catch {
            handleError(error)
        }
    }

    func addSuggestion(_ suggestion: SuggestionEntity) {
        suggestions.insert(suggestion, at: 0)
    }

    func updateSuggestion(_ suggestion: SuggestionEntity) {
        if let index = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
            suggestions[index] = suggestion
        }
    }

    func getCurrentVote(for suggestionId: String) -> VoteType? {
        return currentVotes[suggestionId]
    }

    // MARK: - Private Methods

    private func applyFilter() {
        if let filter = selectedFilter {
            suggestions = allSuggestions.filter { $0.status == filter }
        } else {
            suggestions = allSuggestions
        }
    }

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true

        LogManager.shared.devLog(.error, "SuggestionListViewModel error: \(error)")
    }
}
