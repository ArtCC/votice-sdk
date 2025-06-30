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
        VStack(spacing: theme.spacing.sm) {
            ZStack {
                Circle()
                    .fill(theme.colors.primary.opacity(0.1))
                    .frame(width: 65, height: 65)
                    .scaleEffect(isAnimating ? 1.15 : 1.0)
                    .opacity(isAnimating ? 0.3 : 0.6)
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: theme.colors.primary))
                    .scaleEffect(1.15)
                    .rotationEffect(.degrees(isAnimating ? 360 : 0))
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
            Text(message)
                .font(theme.typography.headline)
                .foregroundColor(theme.colors.onBackground)
                .multilineTextAlignment(.center)
        }
        .padding(theme.spacing.xl)
    }
}
