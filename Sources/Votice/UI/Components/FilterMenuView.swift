//
//  FilterMenuView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 9/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct FilterMenuView: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @Binding var isExpanded: Bool

    let selectedFilter: SuggestionStatusEntity?
    let onFilterSelected: (SuggestionStatusEntity?) -> Void

    // MARK: - View

    var body: some View {
        filterButton
            .overlay(alignment: .topTrailing) {
                if isExpanded {
                    filterDropdown
                        .offset(y: 40)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity),
                            removal: .scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity)
                        ))
                        .zIndex(1)
                }
            }
            .onTapGesture {
                if isExpanded {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isExpanded = false
                    }
                }
            }
    }
}

// MARK: - Private

private extension FilterMenuView {
    var filterButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: theme.spacing.xs) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 20, weight: .medium))
                    .foregroundColor(theme.colors.primary)
                if selectedFilter != nil {
                    Circle()
                        .fill(theme.colors.accent)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, theme.spacing.sm)
            .padding(.vertical, theme.spacing.xs)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                    .fill(theme.colors.primary.opacity(0.1))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }

    var filterDropdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            filterOption(title: TextManager.shared.texts.all, filter: nil)
            Divider()
                .background(theme.colors.secondary.opacity(0.05))
            filterOption(title: TextManager.shared.texts.pending, filter: .pending)
            Divider()
                .background(theme.colors.secondary.opacity(0.05))
            filterOption(title: TextManager.shared.texts.accepted, filter: .accepted)
            Divider()
                .background(theme.colors.secondary.opacity(0.05))
            filterOption(title: TextManager.shared.texts.inProgress, filter: .inProgress)
            Divider()
                .background(theme.colors.secondary.opacity(0.05))
            filterOption(title: TextManager.shared.texts.rejected, filter: .rejected)
            Divider()
                .background(theme.colors.secondary.opacity(0.05))
            filterOption(title: TextManager.shared.texts.completed, filter: .completed)
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.top, theme.spacing.xs)
        .frame(width: 150)
    }

    func filterOption(title: String, filter: SuggestionStatusEntity?) -> some View {
        Button {
            onFilterSelected(filter)

            withAnimation(.easeInOut(duration: 0.2)) {
                isExpanded = false
            }
        } label: {
            HStack {
                Text(title)
                    .font(theme.typography.callout)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
                if selectedFilter == filter {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.colors.primary)
                        .font(.callout)
                }
            }
            .padding(.horizontal, theme.spacing.md)
            .padding(.vertical, theme.spacing.sm)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .background(
            Group {
                if selectedFilter == filter {
                    if filter == nil {
                        UnevenRoundedRectangle(
                            topLeadingRadius: theme.cornerRadius.md,
                            topTrailingRadius: theme.cornerRadius.md
                        )
                        .fill(theme.colors.primary.opacity(0.1))
                    } else if filter == .completed {
                        UnevenRoundedRectangle(
                            bottomLeadingRadius: theme.cornerRadius.md,
                            bottomTrailingRadius: theme.cornerRadius.md
                        )
                        .fill(theme.colors.primary.opacity(0.1))
                    } else {
                        Rectangle()
                            .fill(theme.colors.primary.opacity(0.1))
                    }
                } else {
                    Rectangle()
                        .fill(Color.clear)
                }
            }
        )
    }
}
