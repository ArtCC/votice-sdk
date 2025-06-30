//
//  SuggestionListViewModel.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import Combine

@MainActor
final class SuggestionListViewModel: ObservableObject {
    // MARK: - Properties

    @Published var suggestions: [SuggestionEntity] = []
    @Published var isLoading = false
    @Published var showingError = false
    @Published var errorMessage = ""
    @Published var selectedFilter: SuggestionStatusEntity?
    @Published var hasMoreSuggestions = true
    @Published var currentVotes: [String: VoteType] = [:]

    private var allSuggestions: [SuggestionEntity] = []
    private var currentOffset = 0
    private var loadingTask: Task<Void, Never>?

    private let pageSize = 20
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
                // let startAfter = StartAfterRequest(voteCount: nil, createdAt: "")
                let pagination = PaginationRequest(startAfter: nil, pageLimit: 10)
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

                handleError(error)
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
            // let startAfter = StartAfterRequest(voteCount: nil, createdAt: "")
            let pagination = PaginationRequest(startAfter: nil, pageLimit: 10)
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
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .downvote)
            } else {
                response = try await suggestionUseCase.vote(suggestionId: suggestionId, voteType: .upvote)
            }

            if let vote = response.vote {
                LogManager.shared.devLog(.info, "Vote \(vote) for suggestion \(suggestionId)")

                currentVotes[suggestionId] = type
            } else {
                currentVotes.removeValue(forKey: suggestionId)
            }

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

                allSuggestions[index] = newSuggestion

                applyFilter()
            }
        } catch {
            handleError(error)
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
        return currentVotes[suggestionId]
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

    func handleError(_ error: Error) {
        errorMessage = error.localizedDescription

        showingError = true

        LogManager.shared.devLog(.error, "SuggestionListViewModel error: \(error)")
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
}
