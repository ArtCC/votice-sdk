//
//  SuggestionListViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright Arturo Carretero Calvo 2025. All rights reserved.

import Foundation
import Combine

@MainActor
final class SuggestionListViewModel: ObservableObject {
    // MARK: - Properties

    @Published var suggestions: [SuggestionEntity] = []
    @Published var isLoading = false
    @Published var selectedFilter: SuggestionStatusEntity?
    @Published var hasMoreSuggestions = true
    @Published var currentVotes: [String: VoteType] = [:]
    @Published var showingCreateSuggestion = false
    @Published var selectedSuggestion: SuggestionEntity?
    @Published var currentAlert: VoticeAlertEntity?
    @Published var isShowingAlert = false

    private var allSuggestions: [SuggestionEntity] = []
    private var currentOffset = 0
    private var loadingTask: Task<Void, Never>?

    private let pageSize = 10
    private let suggestionUseCase: SuggestionUseCase

    // MARK: - Init

    init(suggestionUseCase: SuggestionUseCase = SuggestionUseCase()) {
        self.suggestionUseCase = suggestionUseCase
    }

    // MARK: - Functions

    func loadSuggestions() async {
        loadingTask?.cancel()

        loadingTask = Task { @MainActor in
            guard !isLoading else {
                return
            }

            isLoading = true
            currentOffset = 0
            hasMoreSuggestions = true

            do {
                let pagination = PaginationRequest(startAfter: nil, pageLimit: pageSize)
                let response = try await suggestionUseCase.fetchSuggestions(pagination: pagination)

                guard !Task.isCancelled else {
                    isLoading = false

                    return
                }

                allSuggestions = response.suggestions

                await loadVoteStatusForSuggestions(response.suggestions)

                applyFilter()

                currentOffset = response.suggestions.count

                hasMoreSuggestions = response.suggestions.count == pageSize
            } catch {
                guard !Task.isCancelled else {
                    isLoading = false

                    return
                }

                showError(message: error.localizedDescription)
            }

            isLoading = false
        }

        await loadingTask?.value
    }

    func loadMoreSuggestions() async {
        guard !isLoading && hasMoreSuggestions else {
            return
        }

        isLoading = true

        do {
            let last = allSuggestions.last
            let startAfter = last != nil ?
            StartAfterRequest(voteCount: last?.voteCount, createdAt: last?.createdAt ?? "") :
            nil
            let pagination = PaginationRequest(startAfter: startAfter, pageLimit: pageSize)
            let response = try await suggestionUseCase.fetchSuggestions(pagination: pagination)

            guard !Task.isCancelled else {
                isLoading = false

                return
            }

            allSuggestions.append(contentsOf: response.suggestions)

            await loadVoteStatusForSuggestions(response.suggestions)

            applyFilter()

            currentOffset += response.suggestions.count

            hasMoreSuggestions = response.suggestions.count == pageSize
        } catch {
            guard !Task.isCancelled else {
                isLoading = false

                return
            }

            showError(message: error.localizedDescription)
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
            let voteTypeToSend: VoteType = hasCurrentVote ? .downvote : .upvote
            let response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: voteTypeToSend)

            currentVotes[suggestionId] = response.vote != nil ? type : nil

            if let updatedSuggestion = response.suggestion,
               let index = allSuggestions.firstIndex(where: { $0.id == suggestionId }) {

                allSuggestions[index] = allSuggestions[index].copyWith(
                    updatedAt: updatedSuggestion.updatedAt,
                    voteCount: updatedSuggestion.voteCount
                )

                applyFilter()
            }
        } catch {
            showError(message: error.localizedDescription)
        }
    }

    func addSuggestion(_ suggestion: SuggestionEntity) {
        selectedFilter = nil

        Task {
            await loadSuggestions()
        }
    }

    func updateSuggestion(_ suggestion: SuggestionEntity) {
        if let allIndex = allSuggestions.firstIndex(where: { $0.id == suggestion.id }) {
            allSuggestions[allIndex] = suggestion
        }

        if let filteredIndex = suggestions.firstIndex(where: { $0.id == suggestion.id }) {
            suggestions[filteredIndex] = suggestion
        }

        Task {
            await loadVoteStatus(for: suggestion.id)
        }
    }

    func getCurrentVote(for suggestionId: String) -> VoteType? {
        currentVotes[suggestionId]
    }

    func presentCreateSuggestionSheet() {
        showingCreateSuggestion = true
    }

    func dismissCreateSuggestionSheet() {
        showingCreateSuggestion = false
    }

    func selectSuggestion(_ suggestion: SuggestionEntity) {
        selectedSuggestion = suggestion
    }

    func deselectSuggestion() {
        selectedSuggestion = nil
    }
}

// MARK: - Private

private extension SuggestionListViewModel {
    func applyFilter() {
        if let filter = selectedFilter {
            suggestions = allSuggestions.filter { $0.status == filter }
        } else {
            suggestions = allSuggestions
        }
    }

    func loadVoteStatusForSuggestions(_ suggestions: [SuggestionEntity]) async {
        await withTaskGroup(of: Void.self) { group in
            for suggestion in suggestions {
                group.addTask { [weak self] in
                    await self?.loadVoteStatus(for: suggestion.id)
                }
            }
        }
    }

    func loadVoteStatus(for suggestionId: String) async {
        do {
            let voteStatus = try await suggestionUseCase.fetchVoteStatus(suggestionId: suggestionId)

            await MainActor.run {
                if voteStatus.hasVoted {
                    currentVotes[suggestionId] = .upvote
                } else {
                    currentVotes.removeValue(forKey: suggestionId)
                }
            }
        } catch {
            LogManager.shared.devLog(.error, "Failed to load vote status for suggestion \(suggestionId): \(error)")
        }
    }

    func showAlert(_ alert: VoticeAlertEntity) {
        currentAlert = alert

        isShowingAlert = true
    }

    func showError(message: String) {
        showAlert(VoticeAlertEntity.error(message: message))
    }
}
