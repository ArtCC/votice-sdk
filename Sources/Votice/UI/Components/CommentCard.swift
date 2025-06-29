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

    @State private var showDeleteAlert = false

    let comment: CommentEntity
    let currentDeviceId: String
    let onDelete: (() -> Void)?

    // MARK: - Init

    init(comment: CommentEntity, currentDeviceId: String, onDelete: (() -> Void)? = nil) {
        self.comment = comment
        self.currentDeviceId = currentDeviceId
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
                if let commentDeviceId = comment.deviceId, commentDeviceId == currentDeviceId, let onDelete = onDelete {
                    Button(role: .destructive) {
                        showDeleteAlert = true
                    } label: {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Delete Comment"),
                            message: Text("Are you sure you want to delete this comment?"),
                            primaryButton: .destructive(Text("Delete")) {
                                onDelete()
                            },
                            secondaryButton: .cancel()
                        )
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
    }
}
