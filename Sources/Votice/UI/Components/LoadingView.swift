//
//  LoadingView.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    @State private var isAnimating = false

    let message: String

    // MARK: - View

    var body: some View {
        VStack(spacing: theme.spacing.xl) {
            ZStack {
                Circle()
                    .fill(theme.colors.primary.opacity(0.1))
                    .frame(width: 80, height: 80)
                    .scaleEffect(isAnimating ? 1.2 : 1.0)
                    .opacity(isAnimating ? 0.3 : 0.6)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                    .scaleEffect(1.5)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            VStack(spacing: theme.spacing.sm) {
                Text(message)
                    .font(theme.typography.headline)
                    .foregroundColor(theme.colors.onBackground)
                    .multilineTextAlignment(.center)
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(theme.colors.primary)
                            .frame(width: 6, height: 6)
                            .scaleEffect(isAnimating ? 1.0 : 0.5)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
            }
        }
        .padding(theme.spacing.xl)
    }
}
