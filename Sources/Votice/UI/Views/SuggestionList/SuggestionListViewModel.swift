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
    @Published var currentVotes: [String: VoteType] = [:]

    private var allSuggestions: [SuggestionEntity] = []
    private var currentOffset = 0
    private let pageSize = 20
    private var loadingTask: Task<Void, Never>?

    // Use Cases
    private let suggestionUseCase: SuggestionUseCase

    init(suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.suggestionUseCase = suggestionUseCase
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
                // let startAfter = StartAfterRequest(voteCount: nil, createdAt: "")
                let pagination = PaginationRequest(startAfter: nil, pageLimit: 10)
                let response = try await suggestionUseCase.fetchSuggestions(pagination: pagination)

                // Check if task was cancelled
                guard !Task.isCancelled else {
                    isLoading = false
                    return
                }

                allSuggestions = response.suggestions

                // Load vote status for each suggestion
                await loadVoteStatusForSuggestions(response.suggestions)

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
            // let startAfter = StartAfterRequest(voteCount: nil, createdAt: "")
            let pagination = PaginationRequest(startAfter: nil, pageLimit: 10)
            let response = try await suggestionUseCase.fetchSuggestions(pagination: pagination)

            // Check if task was cancelled
            guard !Task.isCancelled else {
                isLoading = false
                return
            }

            allSuggestions.append(contentsOf: response.suggestions)

            // Load vote status for new suggestions
            await loadVoteStatusForSuggestions(response.suggestions)

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
            let hasCurrentVote = currentVotes[suggestionId] != nil
            let response: VoteSuggestionResponse

            if hasCurrentVote {
                // User already voted, so this is an unvote action
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .downvote)
            } else {
                // User hasn't voted, so this is a vote action
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .upvote)
            }

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
                    updatedAt: updatedSuggestion.updatedAt,
                    platform: originalSuggestion.platform,
                    createdBy: originalSuggestion.createdBy,
                    status: originalSuggestion.status,
                    source: originalSuggestion.source,
                    commentCount: originalSuggestion.commentCount,
                    voteCount: updatedSuggestion.voteCount
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
        // Update in both allSuggestions and filtered suggestions
        if let allIndex = allSuggestions.firstIndex(where: { $0.id == suggestion.id }) {
            allSuggestions[allIndex] = suggestion
        }

        if let filteredIndex = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
            suggestions[filteredIndex] = suggestion
        }

        // Also reload the vote status for this suggestion to keep currentVotes in sync
        Task {
            await loadVoteStatus(for: suggestion.id)
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

    private func loadVoteStatusForSuggestions(_ suggestions: [SuggestionEntity]) async {
        // Load vote status for each suggestion in parallel
        await withTaskGroup(of: Void.self) { group in
            for suggestion in suggestions {
                group.addTask { [weak self] in
                    await self?.loadVoteStatus(for: suggestion.id)
                }
            }
        }
    }

    private func loadVoteStatus(for suggestionId: String) async {
        do {
            let voteStatus = try await suggestionUseCase.fetchVoteStatus(suggestionId: suggestionId)

            // Update currentVotes based on the vote status
            await MainActor.run {
                if voteStatus.hasVoted {
                    // Since VoteStatusEntity doesn't include the vote type,
                    // we'll assume it's an upvote for now
                    currentVotes[suggestionId] = .upvote
                } else {
                    currentVotes.removeValue(forKey: suggestionId)
                }
            }
        } catch {
            // Log error but don't fail the whole loading process
            LogManager.shared.devLog(.error, "Failed to load vote status for suggestion \(suggestionId): \(error)")
        }
    }
}
