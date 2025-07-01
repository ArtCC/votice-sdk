//
//  View.swift
//  Votice
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

extension View {
    func voticeAlert(isPresented: Binding<Bool>, alert: VoticeAlertEntity) -> some View {
        self.overlay(
            VoticeAlert(alert: alert, isPresented: isPresented)
        )
    }

    func voticeTheme(_ theme: VoticeTheme) -> some View {
        environment(\.voticeTheme, theme)
    }
}
