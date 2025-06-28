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

    private var currentVotes: [String: VoteType] = [:]
    private var currentOffset = 0
    private let pageSize = 20

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
        guard !isLoading else { return }

        isLoading = true
        currentOffset = 0
        hasMoreSuggestions = true

        do {
            let response = try await fetchSuggestionsUseCase.execute()

            suggestions = response.suggestions
            currentOffset = response.suggestions.count
            hasMoreSuggestions = response.suggestions.count == pageSize
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    func loadMoreSuggestions() async {
        guard !isLoading && hasMoreSuggestions else { return }

        isLoading = true

        do {
            let response = try await fetchSuggestionsUseCase.execute()

            suggestions.append(contentsOf: response.suggestions)
            currentOffset += response.suggestions.count
            hasMoreSuggestions = response.suggestions.count == pageSize
        } catch {
            handleError(error)
        }

        isLoading = false
    }

    func refresh() async {
        await loadSuggestions()
    }

    func setFilter(_ status: SuggestionStatusEntity?) {
        selectedFilter = status
        Task {
            await loadSuggestions()
        }
    }

    func vote(on suggestionId: String, type: VoteType) async {
        do {
            let response = try await voteSuggestionUseCase.execute(
                suggestionId: suggestionId,
                voteType: type
            )

            // Update local vote state
            if response.voteStatus.voted {
                currentVotes[suggestionId] = type
            } else {
                currentVotes.removeValue(forKey: suggestionId)
            }

            // Update suggestion vote count in the list
            if let index = suggestions.firstIndex(where: { $0.id == suggestionId }) {
                var updatedSuggestion = suggestions[index]
                // Note: Backend doesn't return updated vote count yet, so we estimate
                if response.voteStatus.voted {
                    updatedSuggestion = SuggestionEntity(
                        id: updatedSuggestion.id,
                        appId: updatedSuggestion.appId,
                        title: updatedSuggestion.title,
                        text: updatedSuggestion.text,
                        description: updatedSuggestion.description,
                        status: updatedSuggestion.status,
                        voteCount: updatedSuggestion.voteCount + (currentVotes[suggestionId] == nil ? 1 : 0),
                        commentCount: updatedSuggestion.commentCount,
                        source: updatedSuggestion.source,
                        createdBy: updatedSuggestion.createdBy,
                        deviceId: updatedSuggestion.deviceId,
                        nickname: updatedSuggestion.nickname,
                        platform: updatedSuggestion.platform,
                        language: updatedSuggestion.language,
                        createdAt: updatedSuggestion.createdAt,
                        updatedAt: updatedSuggestion.updatedAt
                    )
                }
                suggestions[index] = updatedSuggestion
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

    private func handleError(_ error: Error) {
        errorMessage = error.localizedDescription
        showingError = true
        LogManager.shared.devLog(.error, "SuggestionListViewModel error: \(error)")
    }
}
