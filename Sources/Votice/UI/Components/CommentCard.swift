//
//  CommentCard.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct CommentCard: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @StateObject private var alertManager = AlertManager.shared

    let comment: CommentEntity
    let currentDeviceId: String
    let alert: VoticeAlertEntity
    let onDelete: (() -> Void)?

    // MARK: - Init

    init(comment: CommentEntity,
         currentDeviceId: String,
         alert: VoticeAlertEntity,
         onDelete: (() -> Void)? = nil) {
        self.comment = comment
        self.currentDeviceId = currentDeviceId
        self.alert = alert
        self.onDelete = onDelete
    }

    // MARK: - View

    var body: some View {
        VStack(alignment: .leading, spacing: theme.spacing.sm) {
            HStack {
                Text(comment.displayName)
                    .font(theme.typography.subheadline)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
                if let createdAt = comment.createdAt, let date = Date.formatFromISOString(createdAt) {
                    Text(date)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.secondary)
                }
                if let commentDeviceId = comment.deviceId, commentDeviceId == currentDeviceId {
                    Button(role: .destructive) {
                        HapticManager.shared.warning()

                        alertManager.showAlert(alert)
                    } label: {
                        ZStack {
                            Circle()
                                .fill(theme.colors.error.opacity(0.1))
                                .frame(width: 28, height: 28)
                            Image(systemName: "trash.fill")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(theme.colors.error)
                        }
                    }
                }
            }
            Text(comment.text)
                .font(theme.typography.body)
                .foregroundColor(theme.colors.onSurface)
        }
        .padding(theme.spacing.md)
        .background(theme.colors.surface)
        .cornerRadius(theme.cornerRadius.md)
        .voticeAlert(
            isPresented: $alertManager.isShowingAlert,
            alert: alertManager.currentAlert ?? VoticeAlertEntity.error(message: "Unknown error")
        )
    }
}
