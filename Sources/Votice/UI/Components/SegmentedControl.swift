//
//  SegmentedControl.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 7/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct SegmentedControl: View {
    // MARK: - Types

    struct Segment: Identifiable, Hashable {
        let id: Int
        let title: String
    }

    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @Binding var selection: Int

#if os(tvOS)
    private let controlHeight: CGFloat = 45
    private let segmentSpacing: CGFloat = 40
#else
    private let controlHeight: CGFloat = 35
    private let segmentSpacing: CGFloat = 5
#endif

    let segments: [Segment]

    // MARK: - Body

    var body: some View {
#if os(tvOS)
        tvOSBody
#else
        standardBody
#endif
    }
}

// MARK: - Standard Platforms (iOS, iPadOS, macOS)

private extension SegmentedControl {
    var standardBody: some View {
        HStack(spacing: segmentSpacing) {
            ForEach(segments) { segment in
                let isSelected = segment.id == selection

                Button {
                    guard !isSelected else {
                        return
                    }

                    withAnimation(.easeInOut(duration: 0.15)) {
                        selection = segment.id
                    }
                } label: {
                    Text(segment.title)
                        .font(theme.typography.callout)
                        .fontWeight(.medium)
                        .lineLimit(1)
                        .foregroundColor(isSelected ? .white : theme.colors.onBackground)
                        .padding(5)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                                .fill(isSelected ? theme.colors.primary : Color.clear)
                        )
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .frame(height: controlHeight)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                .fill(theme.colors.surface)
                .overlay(
                    RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                        .stroke(theme.colors.primary.opacity(0.1), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
        .padding(.top, theme.spacing.md)
        .padding(.horizontal, theme.spacing.md)
        .padding(.bottom, theme.spacing.xs)
    }
}

// MARK: - tvOS

#if os(tvOS)
private extension SegmentedControl {
    var tvOSBody: some View {
        HStack(spacing: segmentSpacing) {
            ForEach(segments) { segment in
                let isSelected = segment.id == selection

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selection = segment.id
                    }
                } label: {
                    TVOSSegmentButton(
                        title: segment.title,
                        isSelected: isSelected
                    )
                }
                .buttonStyle(.card)
            }
        }
        .frame(height: controlHeight)
        .padding(.vertical, theme.spacing.sm)
        .padding(.horizontal, theme.spacing.xl)
    }
}
#endif
