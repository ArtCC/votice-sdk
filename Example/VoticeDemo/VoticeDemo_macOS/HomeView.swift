//
//  HomeView.swift
//  VoticeDemo_macOS
//
//  Created by Arturo Carretero Calvo on 9/7/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
import VoticeSDK

struct HomeView: View {
    // MARK: - Properties

    @State private var showingFeedbackSheet = false
    @State private var isConfigured = false

    // MARK: - View

    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            HeaderView()
            Divider()
            Button {
                showingFeedbackSheet = true
            } label: {
                Text("Open Feedback")
                    .font(.poppins(.medium, size: 16))
                    .foregroundColor(.white)
                    .padding()
                    .background(.brand)
                    .cornerRadius(15)
            }
            .buttonStyle(.plain)
            Spacer()
            ReadyView(isConfigured: $isConfigured)
                .padding(.bottom, 20)
        }
        .onAppear {
            configureVotice()

            // Optional: Configure custom texts for localization.
            // configureText()
        }
        .sheet(isPresented: $showingFeedbackSheet) {
            Votice.feedbackView(theme: Votice.systemThemeWithCurrentFonts())
        }
    }
}

// MARK: - Private

private extension HomeView {
    func configureVotice() {
        do {
            try Votice.configure(
                apiKey: "4ba07799d26239935babbbc0",
                apiSecret: "417aa14c866d213c243a2f43414505b431dbe59050bd5c2c",
                appId: "uPf6A96Mn3MX6uOkwsFz"
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
