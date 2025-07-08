//
//  SpanishTexts.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 9/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import Foundation
import Votice

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
