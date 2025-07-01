//
//  HomeView.swift
//  VoticeDemo_tvOS
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
import Votice

struct HomeView: View {
    // MARK: - Properties

    @State private var showingFeedbackSheet = false
    @State private var showingFeedbackSheetWithCustomTheme = false
    @State private var isConfigured = false

    // MARK: - View

    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 10) {
                Image(systemName: "star.bubble")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                Text("Votice SDK Demo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Text("Test all the feedback features")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Divider()
            HStack(spacing: 30) {
                // Option 1: Sheet/Modal
                VStack(spacing: 8) {
                    Text("Option 1: Modal Presentation")
                        .font(.headline)
                    Button("Show Feedback Sheet") {
                        showingFeedbackSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                // Option 2: Navigation
                VStack(spacing: 8) {
                    Text("Option 2: Navigation Push")
                        .font(.headline)
                    NavigationLink("Navigate to Feedback") {
                        Votice.feedbackView()
                    }
                    .buttonStyle(.borderedProminent)
                }
                // Custom Theme Example
                VStack(spacing: 8) {
                    Text("Option 3: Custom Theme")
                        .font(.headline)
                    Button("Feedback with Custom Theme") {
                        showingFeedbackSheetWithCustomTheme = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            Spacer()
            // Configuration Status
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isConfigured ? .green : .red)
                    Text("SDK Configuration: \(isConfigured ? "✅ Ready" : "❌ Not Configured")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if isConfigured {
                    Text("Ready to collect feedback!")
                        .font(.caption2)
                        .foregroundColor(.green)
                }
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingFeedbackSheet) {
            Votice.feedbackView()
        }
        .sheet(isPresented: $showingFeedbackSheetWithCustomTheme) {
            let customTheme = Votice.createTheme(primaryColor: .red,
                                                 backgroundColor: Color(.white),
                                                 surfaceColor: Color(.blue))

            Votice.feedbackView(theme: customTheme)
        }
        .onAppear {
            configurateSDK()
        }
    }
}

// MARK: - Private

private extension HomeView {
    /// Configures the Votice SDK with the provided API key, secret, and app ID.
    func configurateSDK() {
        do {
            try Votice.configure(
                apiKey: "f2ba766c1f5311abb15cb49c",
                apiSecret: "d20d4556d837924dee6e3bc4a4b43ce260a0ea221c2f5500",
                appId: "kJnOJXuO1T8hKRQ0Qo9V"
            )

            debugPrint("✅ Votice SDK configured successfully!")

            // Update configuration status
            isConfigured = Votice.isConfigured
        } catch {
            debugPrint("❌ Configuration failed: \(error)")

            // Update configuration status
            isConfigured = false
        }
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
