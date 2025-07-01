//
//  TextManagerTests.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 31/12/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Testing
@testable import Votice
import Foundation

// MARK: - Mock Texts Implementation

struct MockVoticeTexts: VoticeTextsProtocol {
    // MARK: - General

    let cancel = "Cancelar"
    let error = "Error"
    let ok = "Aceptar"
    let submit = "Enviar"
    let optional = "Opcional"

    // MARK: - Suggestion List

    let loadingSuggestions = "Cargando sugerencias..."
    let noSuggestionsYet = "No hay sugerencias aún."
    let beFirstToSuggest = "¡Sé el primero en sugerir algo!"
    let featureRequests = "Solicitudes de funciones"
    let all = "Todas"
    let pending = "Pendiente"
    let accepted = "Aceptada"
    let inProgress = "En progreso"
    let completed = "Completada"
    let rejected = "Rechazada"
    let tapPlusToGetStarted = "Toca + para empezar"
    let loadingMore = "Cargando más..."

    // MARK: - Suggestion Detail

    let suggestionTitle = "Sugerencia"
    let close = "Cerrar"
    let deleteSuggestionTitle = "Eliminar Sugerencia"
    let deleteSuggestionMessage = "¿Estás seguro de que quieres eliminar esta sugerencia?"
    let delete = "Eliminar"
    let suggestedBy = "Sugerido por"
    let suggestedAnonymously = "Sugerido anónimamente"
    let votes = "votos"
    let comments = "comentarios"
    let commentsSection = "Comentarios"
    let loadingComments = "Cargando comentarios..."
    let noComments = "No hay comentarios aún. ¡Sé el primero en comentar!"
    let addComment = "Añadir comentario"
    let yourComment = "Tu Comentario"
    let shareYourThoughts = "Comparte tus pensamientos..."
    let yourNameOptional = "Tu Nombre (Opcional)"
    let enterYourName = "Introduce tu nombre"
    let newComment = "Nuevo Comentario"
    let post = "Publicar"
    let deleteCommentTitle = "Eliminar Comentario"
    let deleteCommentMessage = "¿Estás seguro de que quieres eliminar este comentario?"
    let deleteCommentPrimary = "Eliminar"

    // MARK: - Create Suggestion

    let newSuggestion = "Nueva Sugerencia"
    let shareYourIdea = "Comparte tu idea"
    let helpUsImprove = "Ayúdanos a mejorar sugiriendo nuevas funciones o mejoras."
    let title = "Título"
    let titlePlaceholder = "Introduce un título breve para tu sugerencia"
    let keepItShort = "Manténlo corto y descriptivo"
    let descriptionOptional = "Descripción (Opcional)"
    let descriptionPlaceholder = "Describe tu sugerencia en detalle..."
    let explainWhyUseful = "Explica por qué esta función sería útil"
    let yourNameOptionalCreate = "Tu Nombre (Opcional)"
    let enterYourNameCreate = "Introduce tu nombre"
    let leaveEmptyAnonymous = "Déjalo vacío para enviar anónimamente"
}

// MARK: - TextManager Tests

@Test("TextManager should initialize with default texts")
func testTextManagerInitialization() async {
    // Given
    let manager = TextManager.shared

    // When
    let texts = manager.texts

    // Then
    #expect(texts.cancel == "Cancel")
    #expect(texts.error == "Error")
    #expect(texts.ok == "OK")
    #expect(texts.submit == "Submit")
    #expect(texts.optional == "Optional")
    #expect(texts.loadingSuggestions == "Loading suggestions...")
    #expect(texts.featureRequests == "Feature Requests")
    #expect(texts.newSuggestion == "New Suggestion")
}

@Test("TextManager should update texts correctly")
func testTextManagerUpdateTexts() async {
    // Given
    let manager = TextManager.shared
    let mockTexts = MockVoticeTexts()

    // When
    manager.setTexts(mockTexts)
    let updatedTexts = manager.texts

    // Then
    #expect(updatedTexts.cancel == "Cancelar")
    #expect(updatedTexts.error == "Error")
    #expect(updatedTexts.ok == "Aceptar")
    #expect(updatedTexts.submit == "Enviar")
    #expect(updatedTexts.optional == "Opcional")
    #expect(updatedTexts.loadingSuggestions == "Cargando sugerencias...")
    #expect(updatedTexts.featureRequests == "Solicitudes de funciones")
    #expect(updatedTexts.newSuggestion == "Nueva Sugerencia")

    // Reset for other tests
    manager.resetToDefault()
}

@Test("TextManager should reset to default texts")
func testTextManagerResetToDefault() async {
    // Given
    let manager = TextManager.shared
    let mockTexts = MockVoticeTexts()
    manager.setTexts(mockTexts)

    // Verify it's changed
    #expect(manager.texts.cancel == "Cancelar")

    // When
    manager.resetToDefault()
    let resetTexts = manager.texts

    // Then
    #expect(resetTexts.cancel == "Cancel")
    #expect(resetTexts.error == "Error")
    #expect(resetTexts.ok == "OK")
    #expect(resetTexts.submit == "Submit")
    #expect(resetTexts.optional == "Optional")
    #expect(resetTexts.loadingSuggestions == "Loading suggestions...")
    #expect(resetTexts.featureRequests == "Feature Requests")
    #expect(resetTexts.newSuggestion == "New Suggestion")
}

@Test("TextManager should be thread-safe")
func testTextManagerThreadSafety() async {
    // Given
    let manager = TextManager.shared
    let mockTexts = MockVoticeTexts()
    var results: [String] = []
    let lock = NSLock()

    // When - Access and modify from multiple threads
    await withTaskGroup(of: Void.self) { group in
        // Reader tasks
        for i in 0..<5 {
            group.addTask {
                let text = manager.texts.cancel
                lock.withLock {
                    results.append("read-\(i)-\(text)")
                }
            }
        }

        // Writer tasks
        for i in 0..<3 {
            group.addTask {
                if i % 2 == 0 {
                    manager.setTexts(mockTexts)
                } else {
                    manager.resetToDefault()
                }
                lock.withLock {
                    results.append("write-\(i)")
                }
            }
        }
    }

    // Then - Should not crash and should have all results
    #expect(results.count == 8)
    #expect(results.filter { $0.hasPrefix("read-") }.count == 5)
    #expect(results.filter { $0.hasPrefix("write-") }.count == 3)

    // Final state should be valid
    let finalTexts = manager.texts
    #expect(!finalTexts.cancel.isEmpty)
    #expect(!finalTexts.error.isEmpty)

    // Reset for other tests
    manager.resetToDefault()
}

@Test("TextManager should maintain singleton behavior")
func testTextManagerSingleton() async {
    // Given/When
    let manager1 = TextManager.shared
    let manager2 = TextManager.shared

    // Then
    #expect(manager1 === manager2) // Same instance
}

// swiftlint:disable function_body_length
@Test("TextManager should handle multiple text updates")
func testTextManagerMultipleUpdates() async {
    // Given
    let manager = TextManager.shared
    let mockTexts1 = MockVoticeTexts()

    struct AnotherMockTexts: VoticeTextsProtocol {
        let cancel = "Annuler"
        let error = "Erreur"
        let ok = "D'accord"
        let submit = "Soumettre"
        let optional = "Optionnel"
        let loadingSuggestions = "Chargement des suggestions..."
        let noSuggestionsYet = "Pas encore de suggestions."
        let beFirstToSuggest = "Soyez le premier à suggérer quelque chose!"
        let featureRequests = "Demandes de fonctionnalités"
        let all = "Toutes"
        let pending = "En attente"
        let accepted = "Acceptée"
        let inProgress = "En cours"
        let completed = "Terminée"
        let rejected = "Rejetée"
        let tapPlusToGetStarted = "Appuyez sur + pour commencer"
        let loadingMore = "Charger plus..."
        let suggestionTitle = "Suggestion"
        let close = "Fermer"
        let deleteSuggestionTitle = "Supprimer la suggestion"
        let deleteSuggestionMessage = "Êtes-vous sûr de vouloir supprimer cette suggestion?"
        let delete = "Supprimer"
        let suggestedBy = "Suggéré par"
        let suggestedAnonymously = "Suggéré anonymement"
        let votes = "votes"
        let comments = "commentaires"
        let commentsSection = "Commentaires"
        let loadingComments = "Chargement des commentaires..."
        let noComments = "Pas encore de commentaires. Soyez le premier à commenter!"
        let addComment = "Ajouter un commentaire"
        let yourComment = "Votre commentaire"
        let shareYourThoughts = "Partagez vos pensées..."
        let yourNameOptional = "Votre nom (optionnel)"
        let enterYourName = "Entrez votre nom"
        let newComment = "Nouveau commentaire"
        let post = "Publier"
        let deleteCommentTitle = "Supprimer le commentaire"
        let deleteCommentMessage = "Êtes-vous sûr de vouloir supprimer ce commentaire?"
        let deleteCommentPrimary = "Supprimer"
        let newSuggestion = "Nouvelle suggestion"
        let shareYourIdea = "Partagez votre idée"
        let helpUsImprove = "Aidez-nous à améliorer en suggérant de nouvelles fonctionnalités ou améliorations."
        let title = "Titre"
        let titlePlaceholder = "Entrez un titre bref pour votre suggestion"
        let keepItShort = "Gardez-le court et descriptif"
        let descriptionOptional = "Description (optionnelle)"
        let descriptionPlaceholder = "Décrivez votre suggestion en détail..."
        let explainWhyUseful = "Expliquez pourquoi cette fonctionnalité serait utile"
        let yourNameOptionalCreate = "Votre nom (optionnel)"
        let enterYourNameCreate = "Entrez votre nom"
        let leaveEmptyAnonymous = "Laissez vide pour soumettre anonymement"
    }

    let mockTexts2 = AnotherMockTexts()

    // When - Multiple updates
    manager.setTexts(mockTexts1)
    #expect(manager.texts.cancel == "Cancelar")

    manager.setTexts(mockTexts2)
    #expect(manager.texts.cancel == "Annuler")

    manager.resetToDefault()
    #expect(manager.texts.cancel == "Cancel")

    // Then - Final state should be default
    let finalTexts = manager.texts
    #expect(finalTexts.cancel == "Cancel")
    #expect(finalTexts.error == "Error")
    #expect(finalTexts.ok == "OK")
}
// swiftlint:enable function_body_length

// MARK: - DefaultVoticeTexts Tests

@Test("DefaultVoticeTexts should have all required properties")
func testDefaultVoticeTexts() async {
    // Given
    let texts = DefaultVoticeTexts()

    // Then - General
    #expect(texts.cancel == "Cancel")
    #expect(texts.error == "Error")
    #expect(texts.ok == "OK")
    #expect(texts.submit == "Submit")
    #expect(texts.optional == "Optional")

    // Suggestion List
    #expect(texts.loadingSuggestions == "Loading suggestions...")
    #expect(texts.noSuggestionsYet == "No suggestions yet.")
    #expect(texts.beFirstToSuggest == "Be the first to suggest something!")
    #expect(texts.featureRequests == "Feature Requests")
    #expect(texts.all == "All")
    #expect(texts.pending == "Pending")
    #expect(texts.accepted == "Accepted")
    #expect(texts.inProgress == "In Progress")
    #expect(texts.completed == "Completed")
    #expect(texts.rejected == "Rejected")
    #expect(texts.tapPlusToGetStarted == "Tap + to get started")
    #expect(texts.loadingMore == "Loading more...")

    // Suggestion Detail
    #expect(texts.suggestionTitle == "Suggestion")
    #expect(texts.close == "Close")
    #expect(texts.deleteSuggestionTitle == "Delete Suggestion")
    #expect(texts.deleteSuggestionMessage == "Are you sure you want to delete this suggestion?")
    #expect(texts.delete == "Delete")
    #expect(texts.suggestedBy == "Suggested by")
    #expect(texts.suggestedAnonymously == "Suggested anonymously")
    #expect(texts.votes == "votes")
    #expect(texts.comments == "comments")

    // Create Suggestion
    #expect(texts.newSuggestion == "New Suggestion")
    #expect(texts.shareYourIdea == "Share your idea")
    #expect(texts.title == "Title")
    #expect(texts.titlePlaceholder == "Enter a brief title for your suggestion")
}

@Test("DefaultVoticeTexts should be Sendable")
func testDefaultVoticeTextsSendable() async {
    // Given
    let texts = DefaultVoticeTexts()

    // When - This compiles, proving it's Sendable
    Task {
        _ = texts.cancel
        _ = texts.error
        _ = texts.newSuggestion
    }

    // Then - No assertion needed, compilation proves Sendable conformance
}
