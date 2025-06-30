//
//  ConfigurationManager.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 28/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation

protocol ConfigurationManagerProtocol: Sendable {
    // MARK: - Properties

    var isConfigured: Bool { get }
    var baseURL: String { get }
    var apiKey: String { get }
    var apiSecret: String { get }
    var appId: String { get }

    // MARK: - Public functions

    func configure(apiKey: String, apiSecret: String, appId: String) throws
    func reset()
    func validateConfiguration() throws
}

final class ConfigurationManager: ConfigurationManagerProtocol, @unchecked Sendable {
    // MARK: - Properties

    static let shared = ConfigurationManager()

    private var _apiKey: String = ""
    private var _apiSecret: String = ""
    private var _appId: String = ""
    private var _isConfigured: Bool = false

    private let lock = NSLock()
    private let _baseURL: String = "https://us-central1-memorypost-artcc01.cloudfunctions.net/api"
    private let _configurationId: String = UUID().uuidString

    // MARK: - Public

    var isConfigured: Bool {
        lock.withLock { _isConfigured }
    }

    var baseURL: String {
        return _baseURL
    }

    var configurationId: String {
        return _configurationId
    }

    var apiKey: String {
        lock.withLock { _apiKey }
    }

    var apiSecret: String {
        lock.withLock { _apiSecret }
    }

    var appId: String {
        lock.withLock { _appId }
    }

    // MARK: - Init

    internal init() {}

    // MARK: - Public functions

    func configure(apiKey: String, apiSecret: String, appId: String) throws {
        try lock.withLock {
            guard !_isConfigured else {
                LogManager.shared.devLog(.warning, "Configuration manager is already configured")

                throw ConfigurationError.alreadyConfigured
            }

            // Validate API key
            guard !apiKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                LogManager.shared.devLog(.error, "Invalid API key provided")

                throw ConfigurationError.invalidAPIKey
            }

            // Validate API secret
            guard !apiSecret.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                LogManager.shared.devLog(.error, "Invalid API secret provided")

                throw ConfigurationError.invalidAPISecret
            }

            // Validate app ID
            guard !appId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
                LogManager.shared.devLog(.error, "Invalid app ID provided")

                throw ConfigurationError.invalidAppId
            }

            _apiKey = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
            _apiSecret = apiSecret.trimmingCharacters(in: .whitespacesAndNewlines)
            _appId = appId.trimmingCharacters(in: .whitespacesAndNewlines)
            _isConfigured = true

            LogManager.shared.devLog(.success, "Configuration manager successfully configured")
        }
    }

    func reset() {
        lock.withLock {
            _apiKey = ""
            _apiSecret = ""
            _appId = ""
            _isConfigured = false

            LogManager.shared.devLog(.info, "Configuration manager reset")
        }
    }

    func validateConfiguration() throws {
        guard isConfigured else {
            LogManager.shared.devLog(.error, "Configuration manager is not configured")

            throw ConfigurationError.notConfigured
        }
    }

    // MARK: - Texts

    struct Texts {
        // MARK: - General

        var cancel = "Cancel"
        var error = "Error"
        var ok = "OK"
        var submit = "Submit"

        // MARK: - Suggestion List

        var loadingSuggestions = "Loading suggestions..."
        var noSuggestionsYet = "No suggestions yet."
        var beFirstToSuggest = "Be the first to suggest something!"
        var featureRequests = "Feature Requests"
        var all = "All"
        var pending = "Pending"
        var accepted = "Accepted"
        var inProgress = "In Progress"
        var completed = "Completed"
        var rejected = "Rejected"

        // MARK: - Suggestion Detail

        var suggestionTitle = "Suggestion"
        var close = "Close"
        var deleteSuggestionTitle = "Delete Suggestion"
        var deleteSuggestionMessage = "Are you sure you want to delete this suggestion?"
        var delete = "Delete"
        var suggestedBy = "Suggested by"
        var suggestedAnonymously = "Suggested anonymously"
        var votes = "votes"
        var comments = "comments"
        var commentsSection = "Comments"
        var loadingComments = "Loading comments..."
        var noComments = "No comments yet. Be the first to comment!"
        var addComment = "Add a comment"
        var yourComment = "Your Comment"
        var shareYourThoughts = "Share your thoughts..."
        var yourNameOptional = "Your Name (Optional)"
        var enterYourName = "Enter your name"
        var newComment = "New Comment"
        var post = "Post"
        var deleteCommentTitle = "Delete Comment"
        var deleteCommentMessage = "Are you sure you want to delete this comment?"
        var deleteCommentPrimary = "Delete"

        // MARK: - Create Suggestion

        var newSuggestion = "New Suggestion"
        var shareYourIdea = "Share your idea"
        var helpUsImprove = "Help us improve by suggesting new features or improvements."
        var title = "Title"
        var titlePlaceholder = "Enter a brief title for your suggestion"
        var keepItShort = "Keep it short and descriptive"
        var descriptionOptional = "Description (Optional)"
        var descriptionPlaceholder = "Describe your suggestion in detail..."
        var explainWhyUseful = "Explain why this feature would be useful"
        var yourNameOptionalCreate = "Your Name (Optional)"
        var enterYourNameCreate = "Enter your name"
        var leaveEmptyAnonymous = "Leave empty to submit anonymously"
    }

    // MARK: - Texts Customization

    private(set) static var texts = Texts()

    static func setTexts(_ customTexts: Texts) {
        self.texts = customTexts
    }

    // MARK: - Texts Access

    /// Get the current texts from TextManager
    static var currentTexts: VoticeTextsProtocol {
        TextManager.shared.texts
    }
}
