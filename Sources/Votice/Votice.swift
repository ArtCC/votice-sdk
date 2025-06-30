//
//  Votice.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import SwiftUI

// swiftlint:disable line_length
#if os(macOS) || os(tvOS)
#warning("Votice SDK is currently only supported on iOS and iPadOS. Support for macOS and tvOS will be available in future releases.")
#endif
// swiftlint:enable line_length

// swiftlint:disable type_body_length
public struct Votice {
    // MARK: - Configuration

    /// Configure the Votice SDK with your app's API credentials
    /// - Parameters:
    ///   - apiKey: Your app's API key from Votice Dashboard
    ///   - apiSecret: Your app's API secret from Votice Dashboard
    ///   - appId: Your app's unique identifier (optional, defaults to "default")
    /// - Throws: ConfigurationError if credentials are invalid or already configured
    public static func configure(apiKey: String, apiSecret: String, appId: String) throws {
        try ConfigurationManager.shared.configure(apiKey: apiKey, apiSecret: apiSecret, appId: appId)

        LogManager.debug = true // Enable debug logging for development
    }

    /// Reset the SDK configuration (useful for testing)
    public static func reset() {
        ConfigurationManager.shared.reset()
    }

    /// Check if the SDK is properly configured
    public static var isConfigured: Bool {
        return ConfigurationManager.shared.isConfigured
    }

    // MARK: - UI Presentation

    /// Present the Votice feedback interface
    /// - Parameters:
    ///   - theme: Custom theme for the UI (optional)
    /// - Returns: A SwiftUI View that can be presented modally or embedded
    public static func feedbackView(theme: VoticeTheme? = nil) -> some View {
        SuggestionListView()
            .voticeTheme(theme ?? .default)
    }

    /// Present the Votice feedback interface as a sheet/modal
    /// - Parameters:
    ///   - isPresented: Binding to control the presentation
    ///   - theme: Custom theme for the UI (optional)
    public static func feedbackSheet(isPresented: Binding<Bool>, theme: VoticeTheme? = nil) -> some View {
        EmptyView()
            .sheet(isPresented: isPresented) {
                SuggestionListView()
                    .voticeTheme(theme ?? .default)
            }
    }

    // MARK: - Theme Configuration

    /// Create a custom theme for the Votice UI
    /// - Parameters:
    ///   - primaryColor: Primary color for buttons and accents
    ///   - backgroundColor: Background color for the interface
    ///   - surfaceColor: Surface color for cards and components
    public static func createTheme(
        primaryColor: Color? = nil,
        backgroundColor: Color? = nil,
        surfaceColor: Color? = nil
    ) -> VoticeTheme {
        var colors = VoticeColors.default

        if let primaryColor = primaryColor {
            colors = VoticeColors(
                primary: primaryColor,
                secondary: colors.secondary,
                accent: colors.accent,
                background: backgroundColor ?? colors.background,
                surface: surfaceColor ?? colors.surface,
                onSurface: colors.onSurface,
                onBackground: colors.onBackground,
                success: colors.success,
                warning: colors.warning,
                error: colors.error,
                upvote: colors.upvote,
                downvote: colors.downvote,
                pending: colors.pending,
                accepted: colors.accepted,
                inProgress: colors.inProgress,
                completed: colors.completed,
                rejected: colors.rejected
            )
        }

        return VoticeTheme(colors: colors, typography: .default, spacing: .default, cornerRadius: .default)
    }

    // MARK: - Texts Customization

    public struct Texts {
        var cancel: String
        var error: String
        var ok: String
        var submit: String
        var loadingSuggestions: String
        var noSuggestionsYet: String
        var beFirstToSuggest: String
        var featureRequests: String
        var all: String
        var pending: String
        var accepted: String
        var inProgress: String
        var completed: String
        var rejected: String
        var suggestionTitle: String
        var close: String
        var deleteSuggestionTitle: String
        var deleteSuggestionMessage: String
        var delete: String
        var suggestedBy: String
        var suggestedAnonymously: String
        var votes: String
        var comments: String
        var commentsSection: String
        var loadingComments: String
        var noComments: String
        var addComment: String
        var yourComment: String
        var shareYourThoughts: String
        var yourNameOptional: String
        var enterYourName: String
        var newComment: String
        var post: String
        var deleteCommentTitle: String
        var deleteCommentMessage: String
        var deleteCommentPrimary: String
        var newSuggestion: String
        var shareYourIdea: String
        var helpUsImprove: String
        var title: String
        var titlePlaceholder: String
        var keepItShort: String
        var descriptionOptional: String
        var descriptionPlaceholder: String
        var explainWhyUseful: String
        var yourNameOptionalCreate: String
        var enterYourNameCreate: String
        var leaveEmptyAnonymous: String
    }

    public static func textsType(
        cancel: String = "Cancel",
        error: String = "Error",
        ok: String = "OK",
        submit: String = "Submit",
        loadingSuggestions: String = "Loading suggestions...",
        noSuggestionsYet: String = "No suggestions yet.",
        beFirstToSuggest: String = "Be the first to suggest something!",
        featureRequests: String = "Feature Requests",
        all: String = "All",
        pending: String = "Pending",
        accepted: String = "Accepted",
        inProgress: String = "In Progress",
        completed: String = "Completed",
        rejected: String = "Rejected",
        suggestionTitle: String = "Suggestion",
        close: String = "Close",
        deleteSuggestionTitle: String = "Delete Suggestion",
        deleteSuggestionMessage: String = "Are you sure you want to delete this suggestion?",
        delete: String = "Delete",
        suggestedBy: String = "Suggested by",
        suggestedAnonymously: String = "Suggested anonymously",
        votes: String = "votes",
        comments: String = "comments",
        commentsSection: String = "Comments",
        loadingComments: String = "Loading comments...",
        noComments: String = "No comments yet. Be the first to comment!",
        addComment: String = "Add a comment",
        yourComment: String = "Your Comment",
        shareYourThoughts: String = "Share your thoughts...",
        yourNameOptional: String = "Your Name (Optional)",
        enterYourName: String = "Enter your name",
        newComment: String = "New Comment",
        post: String = "Post",
        deleteCommentTitle: String = "Delete Comment",
        deleteCommentMessage: String = "Are you sure you want to delete this comment?",
        deleteCommentPrimary: String = "Delete",
        newSuggestion: String = "New Suggestion",
        shareYourIdea: String = "Share your idea",
        helpUsImprove: String = "Help us improve by suggesting new features or improvements.",
        title: String = "Title",
        titlePlaceholder: String = "Enter a brief title for your suggestion",
        keepItShort: String = "Keep it short and descriptive",
        descriptionOptional: String = "Description (Optional)",
        descriptionPlaceholder: String = "Describe your suggestion in detail...",
        explainWhyUseful: String = "Explain why this feature would be useful",
        yourNameOptionalCreate: String = "Your Name (Optional)",
        enterYourNameCreate: String = "Enter your name",
        leaveEmptyAnonymous: String = "Leave empty to submit anonymously"
    ) -> Texts {
        .init(
            cancel: cancel,
            error: error,
            ok: ok,
            submit: submit,
            loadingSuggestions: loadingSuggestions,
            noSuggestionsYet: noSuggestionsYet,
            beFirstToSuggest: beFirstToSuggest,
            featureRequests: featureRequests,
            all: all,
            pending: pending,
            accepted: accepted,
            inProgress: inProgress,
            completed: completed,
            rejected: rejected,
            suggestionTitle: suggestionTitle,
            close: close,
            deleteSuggestionTitle: deleteSuggestionTitle,
            deleteSuggestionMessage: deleteSuggestionMessage,
            delete: delete,
            suggestedBy: suggestedBy,
            suggestedAnonymously: suggestedAnonymously,
            votes: votes,
            comments: comments,
            commentsSection: commentsSection,
            loadingComments: loadingComments,
            noComments: noComments,
            addComment: addComment,
            yourComment: yourComment,
            shareYourThoughts: shareYourThoughts,
            yourNameOptional: yourNameOptional,
            enterYourName: enterYourName,
            newComment: newComment,
            post: post,
            deleteCommentTitle: deleteCommentTitle,
            deleteCommentMessage: deleteCommentMessage,
            deleteCommentPrimary: deleteCommentPrimary,
            newSuggestion: newSuggestion,
            shareYourIdea: shareYourIdea,
            helpUsImprove: helpUsImprove,
            title: title,
            titlePlaceholder: titlePlaceholder,
            keepItShort: keepItShort,
            descriptionOptional: descriptionOptional,
            descriptionPlaceholder: descriptionPlaceholder,
            explainWhyUseful: explainWhyUseful,
            yourNameOptionalCreate: yourNameOptionalCreate,
            enterYourNameCreate: enterYourNameCreate,
            leaveEmptyAnonymous: leaveEmptyAnonymous
        )
    }

    // swiftlint:disable function_body_length
    public static func setTexts(_ texts: Texts) {
        let internalTexts = ConfigurationManager.Texts(
            cancel: texts.cancel,
            error: texts.error,
            ok: texts.ok,
            submit: texts.submit,
            loadingSuggestions: texts.loadingSuggestions,
            noSuggestionsYet: texts.noSuggestionsYet,
            beFirstToSuggest: texts.beFirstToSuggest,
            featureRequests: texts.featureRequests,
            all: texts.all,
            pending: texts.pending,
            accepted: texts.accepted,
            inProgress: texts.inProgress,
            completed: texts.completed,
            rejected: texts.rejected,
            suggestionTitle: texts.suggestionTitle,
            close: texts.close,
            deleteSuggestionTitle: texts.deleteSuggestionTitle,
            deleteSuggestionMessage: texts.deleteSuggestionMessage,
            delete: texts.delete,
            suggestedBy: texts.suggestedBy,
            suggestedAnonymously: texts.suggestedAnonymously,
            votes: texts.votes,
            comments: texts.comments,
            commentsSection: texts.commentsSection,
            loadingComments: texts.loadingComments,
            noComments: texts.noComments,
            addComment: texts.addComment,
            yourComment: texts.yourComment,
            shareYourThoughts: texts.shareYourThoughts,
            yourNameOptional: texts.yourNameOptional,
            enterYourName: texts.enterYourName,
            newComment: texts.newComment,
            post: texts.post,
            deleteCommentTitle: texts.deleteCommentTitle,
            deleteCommentMessage: texts.deleteCommentMessage,
            deleteCommentPrimary: texts.deleteCommentPrimary,
            newSuggestion: texts.newSuggestion,
            shareYourIdea: texts.shareYourIdea,
            helpUsImprove: texts.helpUsImprove,
            title: texts.title,
            titlePlaceholder: texts.titlePlaceholder,
            keepItShort: texts.keepItShort,
            descriptionOptional: texts.descriptionOptional,
            descriptionPlaceholder: texts.descriptionPlaceholder,
            explainWhyUseful: texts.explainWhyUseful,
            yourNameOptionalCreate: texts.yourNameOptionalCreate,
            enterYourNameCreate: texts.enterYourNameCreate,
            leaveEmptyAnonymous: texts.leaveEmptyAnonymous
        )

        ConfigurationManager.setTexts(internalTexts)
    }
    // swiftlint:enable function_body_length

    // MARK: - Text Customization

    /// Set custom texts using the VoticeTextsProtocol.
    /// This is the recommended way to customize texts in the SDK.
    ///
    /// Example usage:
    /// ```swift
    /// // Using default English texts
    /// Votice.setTexts(DefaultVoticeTexts())
    ///
    /// // Using localized texts from your app bundle
    /// Votice.setTexts(LocalizedVoticeTexts(bundle: .main))
    ///
    /// // Using custom implementation
    /// struct SpanishTexts: VoticeTextsProtocol {
    ///     let cancel = "Cancelar"
    ///     let error = "Error"
    ///     // ... implement all required properties
    /// }
    /// Votice.setTexts(SpanishTexts())
    /// ```
    public static func setTexts(_ texts: VoticeTextsProtocol) {
        TextManager.shared.setTexts(texts)
    }

    /// Reset texts to the default English implementation
    public static func resetTextsToDefault() {
        TextManager.shared.resetToDefault()
    }

    /// Get a localized texts implementation for automatic translation support.
    /// Requires proper .strings files in your app bundle.
    ///
    /// - Parameters:
    ///   - bundle: Bundle containing the localization files (default: .main)
    ///   - tableName: Table name for strings files (default: nil for Localizable.strings)
    /// - Returns: LocalizedVoticeTexts instance
    public static func localizedTexts(bundle: Bundle = .main, tableName: String? = nil) -> LocalizedVoticeTexts {
        LocalizedVoticeTexts(bundle: bundle, tableName: tableName)
    }

    // MARK: - Legacy (deprecated)

    @available(*, deprecated, message: "Use configure(apiKey:apiSecret:) instead")
    public static func initialize() {
        debugPrint(" Hello, World!")
    }
}
// swiftlint:enable type_body_length
