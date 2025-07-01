//
//  View.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

extension View {
    func voticeTheme(_ theme: VoticeTheme) -> some View {
        environment(\.voticeTheme, theme)
    }
}
