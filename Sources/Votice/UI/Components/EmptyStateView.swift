//
//  EmptyStateView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct EmptyStateView: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @State private var isAnimating = false

    let title: String
    let message: String

    // MARK: - View

    var body: some View {
        VStack {
            Spacer()
            contentView
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Private

private extension EmptyStateView {
    var contentView: some View {
        VStack(spacing: theme.spacing.xl) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [
                                theme.colors.primary.opacity(0.1),
                                theme.colors.accent.opacity(0.05)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 120)
                    .scaleEffect(isAnimating ? 1.05 : 1.0)
                ZStack {
                    Image(systemName: "lightbulb.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(theme.colors.primary.opacity(0.2))
                        .offset(x: 2, y: 2)
                    Image(systemName: "lightbulb.circle.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [theme.colors.primary, theme.colors.accent],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .rotationEffect(.degrees(isAnimating ? 5 : -5))
                ForEach(0..<3) { index in
                    Image(systemName: "sparkle")
                        .font(.system(size: 12))
                        .foregroundColor(theme.colors.accent)
                        .offset(
                            x: CGFloat([30, -35, 25][index]),
                            y: CGFloat([-30, 20, -15][index])
                        )
                        .opacity(isAnimating ? 1.0 : 0.3)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .animation(
                            .easeInOut(duration: 2.0)
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.3),
                            value: isAnimating
                        )
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 3.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            VStack(spacing: theme.spacing.md) {
                Text(title)
                    .font(theme.typography.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(theme.colors.onBackground)
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(theme.typography.body)
                    .foregroundColor(theme.colors.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                HStack {
                    Image(systemName: "arrow.up.circle.fill")
                        .foregroundColor(theme.colors.primary)
                    Text(TextManager.shared.texts.tapPlusToGetStarted)
                        .font(theme.typography.caption)
                        .foregroundColor(theme.colors.primary)
                }
                .padding(.top, theme.spacing.sm)
            }
        }
        .padding(theme.spacing.xl)
        .background(
            RoundedRectangle(cornerRadius: theme.cornerRadius.lg)
                .fill(theme.colors.surface)
                .shadow(color: theme.colors.primary.opacity(0.1), radius: 8, x: 0, y: 4)
        )
        .padding(.horizontal, theme.spacing.lg)
    }
}
