//
//  HeaderView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 30/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - View

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "star.bubble")
                .font(.system(size: 60))
                .foregroundColor(.accentColor)
            Text("Votice SDK Demo")
                .font(.poppins(.bold, size: 32))
            Text("Test all the feedback features")
                .font(.poppins(.regular, size: 16))
                .foregroundColor(.secondary)
        }
    }
}
