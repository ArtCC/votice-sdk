//
//  TextManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 30/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

// MARK: - VoticeTextsProtocol

/// Protocol that defines all the texts used in the Votice SDK UI.
/// Users can implement this protocol to provide custom translations.
public protocol VoticeTextsProtocol: Sendable {
    // MARK: - General

    var cancel: String { get }
    var error: String { get }
    var ok: String { get }
    var submit: String { get }

    // MARK: - Suggestion List

    var loadingSuggestions: String { get }
    var noSuggestionsYet: String { get }
    var beFirstToSuggest: String { get }
    var featureRequests: String { get }
    var all: String { get }
    var pending: String { get }
    var accepted: String { get }
    var inProgress: String { get }
    var completed: String { get }
    var rejected: String { get }

    // MARK: - Suggestion Detail

    var suggestionTitle: String { get }
    var close: String { get }
    var deleteSuggestionTitle: String { get }
    var deleteSuggestionMessage: String { get }
    var delete: String { get }
    var suggestedBy: String { get }
    var suggestedAnonymously: String { get }
    var votes: String { get }
    var comments: String { get }
    var commentsSection: String { get }
    var loadingComments: String { get }
    var noComments: String { get }
    var addComment: String { get }
    var yourComment: String { get }
    var shareYourThoughts: String { get }
    var yourNameOptional: String { get }
    var enterYourName: String { get }
    var newComment: String { get }
    var post: String { get }
    var deleteCommentTitle: String { get }
    var deleteCommentMessage: String { get }
    var deleteCommentPrimary: String { get }

    // MARK: - Create Suggestion

    var newSuggestion: String { get }
    var shareYourIdea: String { get }
    var helpUsImprove: String { get }
    var title: String { get }
    var titlePlaceholder: String { get }
    var keepItShort: String { get }
    var descriptionOptional: String { get }
    var descriptionPlaceholder: String { get }
    var explainWhyUseful: String { get }
    var yourNameOptionalCreate: String { get }
    var enterYourNameCreate: String { get }
    var leaveEmptyAnonymous: String { get }
}

// MARK: - DefaultVoticeTexts

/// Default English implementation of VoticeTextsProtocol
public struct DefaultVoticeTexts: VoticeTextsProtocol {
    public init() {}

    // MARK: - General

    public let cancel = "Cancel"
    public let error = "Error"
    public let ok = "OK"
    public let submit = "Submit"

    // MARK: - Suggestion List

    public let loadingSuggestions = "Loading suggestions..."
    public let noSuggestionsYet = "No suggestions yet."
    public let beFirstToSuggest = "Be the first to suggest something!"
    public let featureRequests = "Feature Requests"
    public let all = "All"
    public let pending = "Pending"
    public let accepted = "Accepted"
    public let inProgress = "In Progress"
    public let completed = "Completed"
    public let rejected = "Rejected"

    // MARK: - Suggestion Detail

    public let suggestionTitle = "Suggestion"
    public let close = "Close"
    public let deleteSuggestionTitle = "Delete Suggestion"
    public let deleteSuggestionMessage = "Are you sure you want to delete this suggestion?"
    public let delete = "Delete"
    public let suggestedBy = "Suggested by"
    public let suggestedAnonymously = "Suggested anonymously"
    public let votes = "votes"
    public let comments = "comments"
    public let commentsSection = "Comments"
    public let loadingComments = "Loading comments..."
    public let noComments = "No comments yet. Be the first to comment!"
    public let addComment = "Add a comment"
    public let yourComment = "Your Comment"
    public let shareYourThoughts = "Share your thoughts..."
    public let yourNameOptional = "Your Name (Optional)"
    public let enterYourName = "Enter your name"
    public let newComment = "New Comment"
    public let post = "Post"
    public let deleteCommentTitle = "Delete Comment"
    public let deleteCommentMessage = "Are you sure you want to delete this comment?"
    public let deleteCommentPrimary = "Delete"

    // MARK: - Create Suggestion

    public let newSuggestion = "New Suggestion"
    public let shareYourIdea = "Share your idea"
    public let helpUsImprove = "Help us improve by suggesting new features or improvements."
    public let title = "Title"
    public let titlePlaceholder = "Enter a brief title for your suggestion"
    public let keepItShort = "Keep it short and descriptive"
    public let descriptionOptional = "Description (Optional)"
    public let descriptionPlaceholder = "Describe your suggestion in detail..."
    public let explainWhyUseful = "Explain why this feature would be useful"
    public let yourNameOptionalCreate = "Your Name (Optional)"
    public let enterYourNameCreate = "Enter your name"
    public let leaveEmptyAnonymous = "Leave empty to submit anonymously"
}

// MARK: - LocalizedVoticeTexts

/// Localized implementation that uses NSLocalizedString for automatic localization
/// Users can provide their own bundle for custom translations
public struct LocalizedVoticeTexts: VoticeTextsProtocol {
    // MARK: - Properties

    private let bundle: Bundle
    private let tableName: String?

    // MARK: - Init

    public init(bundle: Bundle = .main, tableName: String? = nil) {
        self.bundle = bundle
        self.tableName = tableName
    }

    // MARK: - General

    public var cancel: String { localized("votice.general.cancel", comment: "Cancel button") }
    public var error: String { localized("votice.general.error", comment: "Error title") }
    public var ok: String { localized("votice.general.ok", comment: "OK button") }
    public var submit: String { localized("votice.general.submit", comment: "Submit button") }

    // MARK: - Suggestion List

    public var loadingSuggestions: String {
        localized("votice.list.loading", comment: "Loading suggestions message")
    }
    public var noSuggestionsYet: String {
        localized("votice.list.empty.title", comment: "No suggestions title")
    }
    public var beFirstToSuggest: String {
        localized("votice.list.empty.message", comment: "Be first to suggest message")
    }
    public var featureRequests: String {
        localized("votice.list.title", comment: "Feature requests title")
    }
    public var all: String { localized("votice.list.filter.all", comment: "All filter") }
    public var pending: String { localized("votice.status.pending", comment: "Pending status") }
    public var accepted: String { localized("votice.status.accepted", comment: "Accepted status") }
    public var inProgress: String { localized("votice.status.inProgress", comment: "In progress status") }
    public var completed: String { localized("votice.status.completed", comment: "Completed status") }
    public var rejected: String { localized("votice.status.rejected", comment: "Rejected status") }

    // MARK: - Suggestion Detail

    public var suggestionTitle: String {
        localized("votice.detail.title", comment: "Suggestion detail title")
    }
    public var close: String { localized("votice.detail.close", comment: "Close button") }
    public var deleteSuggestionTitle: String {
        localized("votice.detail.delete.title", comment: "Delete suggestion alert title")
    }
    public var deleteSuggestionMessage: String {
        localized("votice.detail.delete.message", comment: "Delete suggestion alert message")
    }
    public var delete: String { localized("votice.general.delete", comment: "Delete button") }
    public var suggestedBy: String {
        localized("votice.detail.suggestedBy", comment: "Suggested by label")
    }
    public var suggestedAnonymously: String {
        localized("votice.detail.anonymous", comment: "Anonymous suggestion label")
    }
    public var votes: String { localized("votice.detail.votes", comment: "Votes label") }
    public var comments: String { localized("votice.detail.comments", comment: "Comments label") }
    public var commentsSection: String {
        localized("votice.detail.commentsSection", comment: "Comments section title")
    }
    public var loadingComments: String {
        localized("votice.detail.loadingComments", comment: "Loading comments message")
    }
    public var noComments: String {
        localized("votice.detail.noComments", comment: "No comments message")
    }
    public var addComment: String {
        localized("votice.detail.addComment", comment: "Add comment button")
    }
    public var yourComment: String {
        localized("votice.comment.yourComment", comment: "Your comment label")
    }
    public var shareYourThoughts: String {
        localized("votice.comment.placeholder", comment: "Share thoughts placeholder")
    }
    public var yourNameOptional: String {
        localized("votice.comment.name", comment: "Your name optional label")
    }
    public var enterYourName: String {
        localized("votice.comment.namePlaceholder", comment: "Enter name placeholder")
    }
    public var newComment: String {
        localized("votice.comment.new", comment: "New comment title")
    }
    public var post: String { localized("votice.comment.post", comment: "Post button") }
    public var deleteCommentTitle: String {
        localized("votice.comment.delete.title", comment: "Delete comment alert title")
    }
    public var deleteCommentMessage: String {
        localized("votice.comment.delete.message", comment: "Delete comment alert message")
    }
    public var deleteCommentPrimary: String {
        localized("votice.comment.delete.action", comment: "Delete comment action")
    }

    // MARK: - Create Suggestion

    public var newSuggestion: String {
        localized("votice.create.title", comment: "New suggestion title")
    }
    public var shareYourIdea: String {
        localized("votice.create.subtitle", comment: "Share your idea subtitle")
    }
    public var helpUsImprove: String {
        localized("votice.create.description", comment: "Help us improve description")
    }
    public var title: String { localized("votice.create.titleLabel", comment: "Title label") }
    public var titlePlaceholder: String {
        localized("votice.create.titlePlaceholder", comment: "Title placeholder")
    }
    public var keepItShort: String {
        localized("votice.create.titleHint", comment: "Keep it short hint")
    }
    public var descriptionOptional: String {
        localized("votice.create.descriptionLabel", comment: "Description optional label")
    }
    public var descriptionPlaceholder: String {
        localized("votice.create.descriptionPlaceholder", comment: "Description placeholder")
    }
    public var explainWhyUseful: String {
        localized("votice.create.descriptionHint", comment: "Explain why useful hint")
    }
    public var yourNameOptionalCreate: String {
        localized("votice.create.nameLabel", comment: "Your name optional create label")
    }
    public var enterYourNameCreate: String {
        localized("votice.create.namePlaceholder", comment: "Enter name create placeholder")
    }
    public var leaveEmptyAnonymous: String {
        localized("votice.create.nameHint", comment: "Leave empty anonymous hint")
    }

    // MARK: - Localization Helper

    private func localized(_ key: String, comment: String = "") -> String {
        NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: comment)
    }
}

// MARK: - TextManager

/// Centralized manager for handling texts in the Votice SDK
final class TextManager: @unchecked Sendable {
    // MARK: - Properties

    static let shared = TextManager()

    private var _texts: VoticeTextsProtocol
    private let lock = NSLock()

    // MARK: - Public

    var texts: VoticeTextsProtocol {
        lock.withLock { _texts }
    }

    // MARK: - Init

    private init() {
        _texts = DefaultVoticeTexts()
    }

    // MARK: - Public functions

    func setTexts(_ texts: VoticeTextsProtocol) {
        lock.withLock {
            _texts = texts

            LogManager.shared.devLog(.info, "Text manager updated with custom texts")
        }
    }

    func resetToDefault() {
        lock.withLock {
            _texts = DefaultVoticeTexts()

            LogManager.shared.devLog(.info, "Text manager reset to default texts")
        }
    }
}
