//
//  HomeView.swift
//  VoticeDemo_macOS
//
//  Created by Arturo Carretero Calvo on 9/7/25.
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
            Spacer()
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
            Divider()
            // Demo Options
            VStack(spacing: 20) {
                // Option 1: Sheet/Modal with System Theme
                VStack(spacing: 8) {
                    Text("Option 1: Modal Presentation")
                        .font(.poppins(.semiBold, size: 18))
                    Button("Show Feedback Sheet") {
                        showingFeedbackSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.poppins(.medium, size: 16))
                    .controlSize(.large)
                }
                // Option 2: Custom Advanced Theme
                VStack(spacing: 8) {
                    Text("Option 3: Custom Theme")
                        .font(.poppins(.semiBold, size: 18))
                    Button("Feedback with Custom Theme") {
                        showingFeedbackSheetWithCustomTheme = true
                    }
                    .buttonStyle(.borderedProminent)
                    .font(.poppins(.medium, size: 16))
                    .controlSize(.large)
                }
            }
            Spacer()
            // Configuration Status
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: isConfigured ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isConfigured ? .green : .red)
                    Text("SDK Configuration: \(isConfigured ? "" : "")")
                        .font(.poppins(.regular, size: 12))
                        .foregroundColor(.secondary)
                }
                if isConfigured {
                    Text("Ready to collect feedback!")
                        .font(.poppins(.regular, size: 10))
                        .foregroundColor(.green)
                }
            }
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $showingFeedbackSheet) {
            // System theme with Poppins fonts applied
            Votice.feedbackView(theme: Votice.systemThemeWithCurrentFonts())
        }
        .sheet(isPresented: $showingFeedbackSheetWithCustomTheme) {
            // Custom theme with Poppins fonts applied
            let customTheme = Votice.createThemeWithCurrentFonts(
                primaryColor: .blue,
                backgroundColor: .gray,
                surfaceColor: .red
            )

            Votice.feedbackView(theme: customTheme)
        }
        .onAppear {
            configureVotice()

            // Optional: Configure custom texts for localization.
            // configureText()
        }
    }
}

// MARK: - Private

private extension HomeView {
    func configureVotice() {
        do {
            try Votice.configure(
                apiKey: "04d6dbef654cd4ab844d693a",
                apiSecret: "2cafc17210d5a4f2c4c11209b38053e9833447abe96b3c71",
                appId: "2NykJ4WNKWZXd1ezEhKA"
            )

            // Configure Poppins fonts for the SDK
            let poppinsConfig = VoticeFontConfiguration(
                fontFamily: "Poppins",
                weights: [
                    .regular: "Poppins-Regular",
                    .medium: "Poppins-Medium",
                    .semiBold: "Poppins-SemiBold",
                    .bold: "Poppins-Bold"
                ]
            )
            Votice.setFonts(poppinsConfig)

            Votice.setDebugLogging(enabled: false)
            Votice.setCommentIsEnabled(enabled: true)

            isConfigured = Votice.isConfigured

            debugPrint("Votice SDK configured successfully with Poppins fonts!")
        } catch {
            isConfigured = false

            debugPrint("Configuration failed: \(error)")
        }
    }

    func configureText() {
        // Set custom texts for the Votice SDK, isn't necessary but can be useful for localization (default is English)
        Votice.setTexts(SpanishTexts())
    }
}

// MARK: - Preview

#Preview {
    HomeView()
}
