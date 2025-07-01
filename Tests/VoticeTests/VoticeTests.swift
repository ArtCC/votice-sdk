//
//  VoticeTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import SwiftUI

// MARK: - Votice Public API Tests

@Test("Votice should not be configured initially")
func testVoticeInitialState() async {
    // Given
    Votice.reset() // Ensure clean state

    // When/Then
    #expect(Votice.isConfigured == false)
}

@Test("Votice should configure successfully with valid credentials")
func testVoticeConfiguration() async throws {
    // Given
    Votice.reset() // Ensure clean state

    // When
    try Votice.configure(apiKey: "test-key", apiSecret: "test-secret", appId: "test-app")

    // Then
    #expect(Votice.isConfigured == true)

    // Cleanup
    Votice.reset()
}

@Test("Votice should throw error when configuring with invalid credentials")
func testVoticeInvalidConfiguration() async {
    // Given
    Votice.reset() // Ensure clean state

    // When/Then
    #expect(throws: ConfigurationError.invalidAPIKey) {
        try Votice.configure(apiKey: "", apiSecret: "valid-secret", appId: "valid-app")
    }

    #expect(throws: ConfigurationError.invalidAPISecret) {
        try Votice.configure(apiKey: "valid-key", apiSecret: "", appId: "valid-app")
    }

    #expect(Votice.isConfigured == false)
}

@Test("Votice should reset configuration correctly")
func testVoticeReset() async throws {
    // Given
    Votice.reset() // Ensure clean state
    try Votice.configure(apiKey: "test-key", apiSecret: "test-secret", appId: "test-app")
    #expect(Votice.isConfigured == true)

    // When
    Votice.reset()

    // Then
    #expect(Votice.isConfigured == false)
}

@Test("Votice should create feedback view")
func testVoticeFeedbackView() async {
    // Given
    Votice.reset() // Ensure clean state

    // When
    let view = Votice.feedbackView()

    // Then - Should return a View (compilation test - no specific type checking needed)
    _ = view // Just verify it compiles and returns something
}

@Test("Votice should create feedback view with custom theme")
func testVoticeFeedbackViewWithTheme() async {
    // Given
    Votice.reset() // Ensure clean state
    let customTheme = Votice.createTheme(primaryColor: .red, backgroundColor: .blue)

    // When
    let view = Votice.feedbackView(theme: customTheme)

    // Then - Should return a View (compilation test - no specific type checking needed)
    _ = view // Just verify it compiles and returns something
}

@Test("Votice should create system theme")
func testVoticeSystemTheme() async {
    // Given/When
    let theme = Votice.systemTheme()

    // Then
    #expect(theme.colors.primary == Color(red: 0.0, green: 0.48, blue: 1.0)) // iOS System Blue
    #expect(theme.colors.background == Color.systemBackground)
    #expect(theme.colors.surface == Color.secondarySystemBackground)
}

@Test("Votice should create default theme")
func testVoticeDefaultTheme() async {
    // Given/When
    let theme = Votice.defaultTheme()

    // Then - Should return a valid theme
    #expect(theme.colors.background != nil)
    #expect(theme.colors.surface != nil)
    #expect(theme.colors.primary != nil)
}

@Test("Votice should create custom theme with specific colors")
func testVoticeCustomTheme() async {
    // Given/When
    let theme = Votice.createTheme(
        primaryColor: .red,
        backgroundColor: .black,
        surfaceColor: .white
    )

    // Then
    #expect(theme.colors.primary == .red)
    #expect(theme.colors.background == .black)
    #expect(theme.colors.surface == .white)
}

@Test("Votice should create advanced theme with all parameters")
func testVoticeAdvancedTheme() async {
    // Given/When
    let theme = Votice.createAdvancedTheme(
        primaryColor: .blue,
        secondaryColor: .gray,
        accentColor: .orange,
        backgroundColor: .black,
        surfaceColor: .white,
        destructiveColor: .red,
        successColor: .green,
        warningColor: .yellow,
        errorColor: .red,
        pendingColor: .orange,
        acceptedColor: .blue,
        inProgressColor: .purple,
        completedColor: .green,
        rejectedColor: .red
    )

    // Then
    #expect(theme.colors.primary == .blue)
    #expect(theme.colors.secondary == .gray)
    #expect(theme.colors.accent == .orange)
    #expect(theme.colors.background == .black)
    #expect(theme.colors.surface == .white)
    #expect(theme.colors.success == .green)
    #expect(theme.colors.warning == .yellow)
    #expect(theme.colors.error == .red)
    #expect(theme.colors.pending == .orange)
    #expect(theme.colors.accepted == .blue)
    #expect(theme.colors.inProgress == .purple)
    #expect(theme.colors.completed == .green)
    #expect(theme.colors.rejected == .red)
}

// swiftlint:disable function_body_length
@Test("Votice should handle text customization")
func testVoticeTextCustomization() async {
    // Given
    struct TestTexts: VoticeTextsProtocol {
        let cancel = "Cancelar"
        let error = "Error"
        let ok = "Aceptar"
        let submit = "Enviar"
        let optional = "Opcional"
        let loadingSuggestions = "Cargando..."
        let noSuggestionsYet = "Sin sugerencias"
        let beFirstToSuggest = "Sé el primero"
        let featureRequests = "Funciones"
        let all = "Todas"
        let pending = "Pendiente"
        let accepted = "Aceptada"
        let inProgress = "En progreso"
        let completed = "Completada"
        let rejected = "Rechazada"
        let tapPlusToGetStarted = "Toca +"
        let loadingMore = "Cargando más..."
        let suggestionTitle = "Sugerencia"
        let close = "Cerrar"
        let deleteSuggestionTitle = "Eliminar"
        let deleteSuggestionMessage = "¿Seguro?"
        let delete = "Eliminar"
        let suggestedBy = "Por"
        let suggestedAnonymously = "Anónimo"
        let votes = "votos"
        let comments = "comentarios"
        let commentsSection = "Comentarios"
        let loadingComments = "Cargando comentarios..."
        let noComments = "Sin comentarios"
        let addComment = "Comentar"
        let yourComment = "Tu comentario"
        let shareYourThoughts = "Comparte..."
        let yourNameOptional = "Nombre (Opcional)"
        let enterYourName = "Tu nombre"
        let newComment = "Nuevo comentario"
        let post = "Publicar"
        let deleteCommentTitle = "Eliminar comentario"
        let deleteCommentMessage = "¿Eliminar comentario?"
        let deleteCommentPrimary = "Eliminar"
        let newSuggestion = "Nueva sugerencia"
        let shareYourIdea = "Comparte tu idea"
        let helpUsImprove = "Ayúdanos a mejorar"
        let title = "Título"
        let titlePlaceholder = "Título..."
        let keepItShort = "Breve"
        let descriptionOptional = "Descripción (Opcional)"
        let descriptionPlaceholder = "Descripción..."
        let explainWhyUseful = "¿Por qué es útil?"
        let yourNameOptionalCreate = "Nombre (Opcional)"
        let enterYourNameCreate = "Tu nombre"
        let leaveEmptyAnonymous = "Vacío = anónimo"
    }

    let customTexts = TestTexts()

    // When
    Votice.setTexts(customTexts)

    // Then
    let textManager = TextManager.shared
    #expect(textManager.texts.cancel == "Cancelar")
    #expect(textManager.texts.featureRequests == "Funciones")

    // Cleanup
    Votice.resetTextsToDefault()
    #expect(textManager.texts.cancel == "Cancel")
}

@Test("Votice should reset texts to default")
func testVoticeResetTexts() async {
    // Given
    struct TestTexts: VoticeTextsProtocol {
        let cancel = "Custom Cancel"
        let error = "Error"
        let ok = "OK"
        let submit = "Submit"
        let optional = "Optional"
        let loadingSuggestions = "Loading..."
        let noSuggestionsYet = "No suggestions"
        let beFirstToSuggest = "Be first"
        let featureRequests = "Features"
        let all = "All"
        let pending = "Pending"
        let accepted = "Accepted"
        let inProgress = "In Progress"
        let completed = "Completed"
        let rejected = "Rejected"
        let tapPlusToGetStarted = "Tap +"
        let loadingMore = "Loading more..."
        let suggestionTitle = "Suggestion"
        let close = "Close"
        let deleteSuggestionTitle = "Delete"
        let deleteSuggestionMessage = "Sure?"
        let delete = "Delete"
        let suggestedBy = "By"
        let suggestedAnonymously = "Anonymous"
        let votes = "votes"
        let comments = "comments"
        let commentsSection = "Comments"
        let loadingComments = "Loading comments..."
        let noComments = "No comments"
        let addComment = "Comment"
        let yourComment = "Your comment"
        let shareYourThoughts = "Share..."
        let yourNameOptional = "Name (Optional)"
        let enterYourName = "Your name"
        let newComment = "New comment"
        let post = "Post"
        let deleteCommentTitle = "Delete comment"
        let deleteCommentMessage = "Delete comment?"
        let deleteCommentPrimary = "Delete"
        let newSuggestion = "New suggestion"
        let shareYourIdea = "Share idea"
        let helpUsImprove = "Help improve"
        let title = "Title"
        let titlePlaceholder = "Title..."
        let keepItShort = "Brief"
        let descriptionOptional = "Description (Optional)"
        let descriptionPlaceholder = "Description..."
        let explainWhyUseful = "Why useful?"
        let yourNameOptionalCreate = "Name (Optional)"
        let enterYourNameCreate = "Your name"
        let leaveEmptyAnonymous = "Empty = anonymous"
    }

    Votice.setTexts(TestTexts())
    let textManager = TextManager.shared
    #expect(textManager.texts.cancel == "Custom Cancel")

    // When
    Votice.resetTextsToDefault()

    // Then
    #expect(textManager.texts.cancel == "Cancel")
    #expect(textManager.texts.featureRequests == "Feature Requests")
}
// swiftlint:enable function_body_length

// MARK: - Legacy Tests (deprecated method)

@Test("Votice deprecated initialize method should work")
func testVoticeDeprecatedInitialize() async {
    // Given/When/Then - Just ensure it doesn't crash
    #expect(throws: Never.self) {
        Votice.initialize()
    }
}
