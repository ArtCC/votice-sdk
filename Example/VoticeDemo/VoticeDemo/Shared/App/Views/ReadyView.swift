//
//  ReadyView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 30/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

struct ReadyView: View {
    // MARK: - Properties

    @Binding var isConfigured: Bool

    // MARK: - View

    var body: some View {
        VStack(spacing: 10) {
            Label {
                Text("SDK Configuration:")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.secondary)
            } icon: {
                Image(systemName: isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isConfigured ? .green : .red)
            }
            if isConfigured {
                Text("Ready to collect feedback!")
                    .font(.poppins(.regular, size: 14))
                    .foregroundColor(.green)
            }
        }
    }
}
