//
//  CustomSegmentedControl.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 7/9/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct CustomSegmentedControl: View {
    // MARK: - Types

    struct Segment: Identifiable, Hashable {
        let id: Int
        let title: String
    }

    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @Binding var selection: Int

    private var controlHeight: CGFloat {
#if os(tvOS)
        50
#else
        35
#endif
    }

    private let segmentSpacing: CGFloat = 5
    private let innerVerticalPadding: CGFloat = 5
    private let innerHorizontalPadding: CGFloat = 5

    let segments: [Segment]

    // MARK: - Body

    var body: some View {
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
                        .padding(.vertical, innerVerticalPadding)
                        .padding(.horizontal, innerHorizontalPadding)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: theme.cornerRadius.sm)
                                .fill(isSelected ? theme.colors.primary : Color.clear)
                        )
                        .contentShape(Rectangle())
                }
#if os(iOS) || os(macOS)
                .buttonStyle(.plain)
#else
                .buttonStyle(.card)
#endif
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
                .shadow(color: theme.colors.primary.opacity(0.05), radius: 2, x: 0, y: 1)
        )
        .padding(.top, theme.spacing.md)
        .padding(.horizontal, theme.spacing.md)
        .padding(.bottom, theme.spacing.xs)
    }
}
