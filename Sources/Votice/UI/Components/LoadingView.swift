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

    // MARK: - View

    var body: some View {
        VStack(spacing: theme.spacing.md) {
            ProgressView()
                .scaleEffect(1.2)
            Text("Loading suggestions...")
                .font(theme.typography.body)
                .foregroundColor(theme.colors.secondary)
        }
    }
}
