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

    private var showCompletedSeparately: Bool {
        ConfigurationManager.shared.showCompletedSeparately
    }
    private var optionalVisible: Set<SuggestionStatusEntity> {
        ConfigurationManager.shared.optionalVisibleStatuses
    }
    private var orderedVisibleStatuses: [SuggestionStatusEntity] {
        // Mandatory always (except completed if separated)
        var result: [SuggestionStatusEntity] = []

        // Optional insertion order: accepted, blocked, rejected if present
        let optionalOrder: [SuggestionStatusEntity] = [.accepted, .blocked, .rejected]

        // Append optional in defined order if present
        for status in optionalOrder where optionalVisible.contains(status) {
            result.append(status)
        }

        // Always append completed if not separated
        if !showCompletedSeparately {
            result.append(.completed)
        }

        // Always append in-progress and pending
        result.append(.inProgress)
        result.append(.pending)

        // Safety check: ensure blocked and rejected are included if in optionalVisible
        if optionalVisible.contains(.rejected) && !result.contains(.rejected) {
            result.append(.rejected)
        }

        return result
    }

    let selectedFilter: SuggestionStatusEntity?
    let onFilterSelected: (SuggestionStatusEntity?) -> Void

    // MARK: - Init

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
    // MARK: - Properties

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
        .buttonStyle(.plain)
    }

    var filterDropdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            filterOption(title: TextManager.shared.texts.all, filter: nil)
            ForEach(Array(orderedVisibleStatuses.enumerated()), id: \.element) { _, status in
                Divider().background(theme.colors.secondary.opacity(0.05))

                filterOption(title: title(for: status), filter: status)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.md)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.top, theme.spacing.xs)
        .frame(width: 150)
    }

    // MARK: - Functions

    func title(for status: SuggestionStatusEntity) -> String {
        switch status {
        case .accepted: return TextManager.shared.texts.accepted
        case .blocked: return TextManager.shared.texts.blocked
        case .completed: return TextManager.shared.texts.completed
        case .inProgress: return TextManager.shared.texts.inProgress
        case .pending: return TextManager.shared.texts.pending
        case .rejected: return TextManager.shared.texts.rejected
        }
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
            .background(selectedFilter == filter ? theme.colors.primary.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}
