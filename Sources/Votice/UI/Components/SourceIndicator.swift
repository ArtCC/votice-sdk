//
//  SourceIndicator.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct SourceIndicator: View {
    // MARK: - Properties

    @Environment(\.voticeTheme) private var theme

    private var icon: String {
        switch source {
        case .dashboard:
            return "desktop_computer"
        case .sdk:
            return "mobile"
        }
    }

    let source: SuggestionSource

    // MARK: - View

    var body: some View {
        Image(systemName: icon)
            .font(.caption)
            .foregroundColor(theme.colors.secondary)
    }
}
