//
//  HomeView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
import Votice

struct HomeView: View {
    // MARK: - Properties

    @State private var showingFeedbackSheet = false
    @State private var showingFeedbackSheetWithCustomTheme = false
    @State private var isConfigured = false

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                VStack(spacing: 10) {
                    Image(systemName: "star.bubble")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    Text("Votice SDK Demo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Test all the feedback features")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Divider()
                // Demo Options
                VStack(spacing: 20) {
                    // Option 1: Sheet/Modal with System Theme
                    VStack(spacing: 8) {
                        Text("Option 1: Modal Presentation")
                            .font(.headline)
                        Button("Show Feedback Sheet") {
                            showingFeedbackSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    // Option 2: Navigation with Light Theme
                    VStack(spacing: 8) {
                        Text("Option 2: Navigation Push")
                            .font(.headline)
                        NavigationLink("Navigate to Feedback") {
                            Votice.feedbackView(theme: Votice.systemTheme())
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    // Option 3: Custom Advanced Theme
                    VStack(spacing: 8) {
                        Text("Option 3: Custom Theme")
                            .font(.headline)
                        Button("Feedback with Custom Theme") {
                            showingFeedbackSheetWithCustomTheme = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                }
                Spacer()
                // Configuration Status
                VStack(spacing: 4) {
                    HStack {
                        Image(systemName: isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                            .foregroundColor(isConfigured ? .green : .red)
                        Text("SDK Configuration: \(isConfigured ? "✅ Ready" : "❌ Not Configured")")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    if isConfigured {
                        Text("Ready to collect feedback!")
                            .font(.caption2)
                            .foregroundColor(.green)
                    }
                }
            }
            .padding()
            .navigationTitle("Votice Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
        .sheet(isPresented: $showingFeedbackSheet) {
            // System theme that adapts to light/dark mode automatically
            Votice.feedbackView(theme: Votice.systemTheme())
        }
        .sheet(isPresented: $showingFeedbackSheetWithCustomTheme) {
            // Example of advanced theme customization
            let customTheme = Votice.createAdvancedTheme(
                primaryColor: .purple,
                accentColor: .pink,
                backgroundColor: Color(.systemBackground),
                surfaceColor: Color(.secondarySystemBackground),
                destructiveColor: .red,
                successColor: .mint,
                warningColor: .orange
            )

            Votice.feedbackView(theme: customTheme)
        }
        .onAppear {
            configureVotice()

            // Optional: Configure custom texts for localization.
            // configureText()
        }
    }
}

// MARK: - Private

private extension HomeView {
    func configureVotice() {
        do {
            try Votice.configure(
                apiKey: "f36c62a3e9fa895cc5f6f89e",
                apiSecret: "9c5288e2584c3be913c8c216123dc757873c562720d3ab87",
                appId: "uN2b1hDJxSXNwzse47xE"
            )

            Votice.setDebugLogging(enabled: true)

            isConfigured = Votice.isConfigured

            debugPrint("Votice SDK configured successfully!")
        } catch {
            isConfigured = false

            debugPrint("Configuration failed: \(error)")
        }
    }

    func configureText() {
        // Set custom texts for the Votice SDK, isn't necessary but can be useful for localization (default is English)
        Votice.setTexts(SpanishTexts())
    }
}

// MARK: - Custom Spanish Implementation

struct SpanishTexts: VoticeTextsProtocol {
    // MARK: - General

    let cancel = "Cancelar"
    let error = "Error"
    let ok = "OK"
    let submit = "Enviar"
    let optional = "Opcional"
    let success = "Éxito"
    let warning = "Advertencia"
    let info = "Información"
    let genericError = "Algo salió mal. Por favor, inténtalo de nuevo."

    // MARK: - Suggestion List

    let loadingSuggestions = "Cargando sugerencias..."
    let noSuggestionsYet = "Aún no hay sugerencias."
    let beFirstToSuggest = "¡Sé el primero en sugerir algo!"
    let featureRequests = "Sugerencias"
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
    let deleteSuggestionTitle = "Eliminar sugerencia"
    let deleteSuggestionMessage = "¿Seguro que quieres eliminar esta sugerencia?"
    let delete = "Eliminar"
    let suggestedBy = "Sugerido por"
    let suggestedAnonymously = "Sugerido anónimamente"
    let votes = "votos"
    let comments = "comentarios"
    let commentsSection = "Comentarios"
    let loadingComments = "Cargando comentarios..."
    let noComments = "Aún no hay comentarios. ¡Sé el primero en comentar!"
    let addComment = "Agregar un comentario"
    let yourComment = "Tu comentario"
    let shareYourThoughts = "Comparte tus ideas..."
    let yourNameOptional = "Tu nombre (opcional)"
    let enterYourName = "Introduce tu nombre"
    let newComment = "Nuevo comentario"
    let post = "Publicar"
    let deleteCommentTitle = "Eliminar comentario"
    let deleteCommentMessage = "¿Seguro que quieres eliminar este comentario?"
    let deleteCommentPrimary = "Eliminar"

    // MARK: - Create Suggestion

    let newSuggestion = "Nueva sugerencia"
    let shareYourIdea = "Comparte tu idea"
    let helpUsImprove = "Ayúdanos a mejorar sugiriendo nuevas funciones o mejoras."
    let title = "Título (Mínimo 3 caracteres)"
    let titlePlaceholder = "Introduce un título breve para tu sugerencia"
    let keepItShort = "Mantenlo corto y descriptivo"
    let descriptionOptional = "Descripción (opcional)"
    let descriptionPlaceholder = "Describe tu sugerencia en detalle..."
    let explainWhyUseful = "Explica por qué esta función sería útil"
    let yourNameOptionalCreate = "Tu nombre (opcional)"
    let enterYourNameCreate = "Introduce tu nombre"
    let leaveEmptyAnonymous = "Déjalo vacío para enviar anónimamente"
}

// MARK: - Preview

#Preview {
    HomeView()
}
