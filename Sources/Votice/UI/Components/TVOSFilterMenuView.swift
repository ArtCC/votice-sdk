//
//  TVOSFilterMenuView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 8/10/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

#if os(tvOS)
struct TVOSFilterMenuView: View {
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

    // MARK: - View

    var body: some View {
        filterButton
            .overlay(alignment: .topTrailing) {
                if isExpanded {
                    filterDropdown
                        .offset(y: 60)
                        .transition(.asymmetric(
                            insertion: .scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity),
                            removal: .scale(scale: 0.95, anchor: .topTrailing).combined(with: .opacity)
                        ))
                        .zIndex(1)
                }
            }
    }
}

// MARK: - Private

private extension TVOSFilterMenuView {
    // MARK: - Properties

    var filterButton: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        } label: {
            HStack(spacing: theme.spacing.sm) {
                Image(systemName: "line.3.horizontal.decrease.circle.fill")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(theme.colors.primary)
                Text(currentFilterTitle)
                    .font(theme.typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.onBackground)
                Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(theme.colors.onBackground.opacity(0.7))
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
                if selectedFilter != nil {
                    Circle()
                        .fill(theme.colors.accent)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .background(
                RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                    .fill(theme.colors.surface)
                    .stroke(theme.colors.primary.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    var filterDropdown: some View {
        VStack(alignment: .leading, spacing: 0) {
            filterOption(title: TextManager.shared.texts.all, filter: nil)
            ForEach(Array(orderedVisibleStatuses.enumerated()), id: \.element) { _, status in
                Divider()
                    .background(theme.colors.secondary.opacity(0.1))

                filterOption(title: title(for: status), filter: status)
            }
        }
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.2), radius: 12, x: 0, y: 6)
        )
        .frame(width: 265)
    }

    private var currentFilterTitle: String {
        if let selectedFilter = selectedFilter {
            return title(for: selectedFilter)
        } else {
            return TextManager.shared.texts.all
        }
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

            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded = false
            }
        } label: {
            HStack {
                Text(title)
                    .font(theme.typography.callout)
                    .fontWeight(.medium)
                    .foregroundColor(theme.colors.onSurface)
                Spacer()
                if selectedFilter == filter {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(theme.colors.primary)
                        .font(.system(size: 18))
                }
            }
            .padding(.horizontal, theme.spacing.lg)
            .padding(.vertical, theme.spacing.md)
            .contentShape(Rectangle())
            .background(selectedFilter == filter ? theme.colors.primary.opacity(0.1) : Color.clear)
        }
        .buttonStyle(.plain)
    }
}
#endif
