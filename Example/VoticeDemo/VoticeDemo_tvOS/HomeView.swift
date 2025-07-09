//
//  HomeView.swift
//  VoticeDemo_tvOS
//
//  Created by Arturo Carretero Calvo on 9/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
import Votice

struct HomeView: View {
    // MARK: - Properties

    var body: some View {
        VStack(spacing: 10) {
            Spacer()
            Image(systemName: "star.bubble")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            Text("Votice SDK Demo")
                .font(.poppins(.bold, size: 32))
            Text("Test all the feedback features")
                .font(.poppins(.regular, size: 16))
                .foregroundColor(.secondary)
            Spacer()
            Text("⚠ Votice SDK is currently only supported on iOS, iPadOS and macOS. Support for tvOS will be available in future releases.")
                .font(.poppins(.regular, size: 16))
                .foregroundColor(.secondary)
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
