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
                    // Option 1: Sheet/Modal
                    VStack(spacing: 8) {
                        Text("Option 1: Modal Presentation")
                            .font(.headline)
                        Button("Show Feedback Sheet") {
                            showingFeedbackSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    // Option 2: Navigation
                    VStack(spacing: 8) {
                        Text("Option 2: Navigation Push")
                            .font(.headline)
                        NavigationLink("Navigate to Feedback") {
                            Votice.feedbackView()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    // Custom Theme Example
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
            Votice.feedbackView()
        }
        .sheet(isPresented: $showingFeedbackSheetWithCustomTheme) {
            let customTheme = Votice.createTheme(primaryColor: .red,
                                                 backgroundColor: Color(.systemBackground),
                                                 surfaceColor: Color(.secondarySystemBackground))

            Votice.feedbackView(theme: customTheme)
        }
        .onAppear {
            configureVotice()
            configureText()
        }
    }
}

// MARK: - Private

private extension HomeView {
    func configureVotice() {
        do {
            try Votice.configure(
                apiKey: "f2ba766c1f5311abb15cb49c",
                apiSecret: "d20d4556d837924dee6e3bc4a4b43ce260a0ea221c2f5500",
                appId: "kJnOJXuO1T8hKRQ0Qo9V"
            )

            debugPrint("✅ Votice SDK configured successfully!")

            isConfigured = Votice.isConfigured
        } catch {
            debugPrint("❌ Configuration failed: \(error)")

            isConfigured = false
        }
    }

    func configureText() {
        let texts = Votice.textsType(
            cancel: "Cancelar",
            error: "Error",
            ok: "OK",
            submit: "Enviar",
            loadingSuggestions: "Cargando sugerencias...",
            noSuggestionsYet: "Aún no hay sugerencias.",
            beFirstToSuggest: "¡Sé el primero en sugerir algo!",
            featureRequests: "Solicitudes de funciones",
            all: "Todas",
            pending: "Pendiente",
            accepted: "Aceptada",
            inProgress: "En progreso",
            completed: "Completada",
            rejected: "Rechazada",
            suggestionTitle: "Sugerencia",
            close: "Cerrar",
            deleteSuggestionTitle: "Eliminar sugerencia",
            deleteSuggestionMessage: "¿Seguro que quieres eliminar esta sugerencia?",
            delete: "Eliminar",
            suggestedBy: "Sugerido por",
            suggestedAnonymously: "Sugerido anónimamente",
            votes: "votos",
            comments: "comentarios",
            commentsSection: "Comentarios",
            loadingComments: "Cargando comentarios...",
            noComments: "Aún no hay comentarios. ¡Sé el primero en comentar!",
            addComment: "Agregar un comentario",
            yourComment: "Tu comentario",
            shareYourThoughts: "Comparte tus ideas...",
            yourNameOptional: "Tu nombre (opcional)",
            enterYourName: "Introduce tu nombre",
            newComment: "Nuevo comentario",
            post: "Publicar",
            deleteCommentTitle: "Eliminar comentario",
            deleteCommentMessage: "¿Seguro que quieres eliminar este comentario?",
            deleteCommentPrimary: "Eliminar",
            newSuggestion: "Nueva sugerencia",
            shareYourIdea: "Comparte tu idea",
            helpUsImprove: "Ayúdanos a mejorar sugiriendo nuevas funciones o mejoras.",
            title: "Título",
            titlePlaceholder: "Introduce un título breve para tu sugerencia",
            keepItShort: "Mantenlo corto y descriptivo",
            descriptionOptional: "Descripción (opcional)",
            descriptionPlaceholder: "Describe tu sugerencia en detalle...",
            explainWhyUseful: "Explica por qué esta función sería útil",
            yourNameOptionalCreate: "Tu nombre (opcional)",
            enterYourNameCreate: "Introduce tu nombre",
            leaveEmptyAnonymous: "Déjalo vacío para enviar anónimamente"
        )

        Votice.setTexts(texts)
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
