//
//  HomeView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI
import VoticeSDK

struct HomeView: View {
    // MARK: - Properties

    @State private var showingFeedbackSheet = false
    @State private var showingFeedbackSheetWithCustomTheme = false
    @State private var isConfigured = false

    // MARK: - View

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 30) {
                        HeaderView()
                        Divider()
                        VStack(spacing: 20) {
                            VStack(spacing: 10) {
                                Text("Option 1: Modal Presentation")
                                    .font(.poppins(.semiBold, size: 18))
                                Button {
                                    showingFeedbackSheet = true
                                } label: {
                                    Text("Show Feedback Sheet")
                                        .font(.poppins(.medium, size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.brand)
                                        .cornerRadius(15)
                                }
                            }
                            VStack(spacing: 10) {
                                Text("Option 2: Navigation Push")
                                    .font(.poppins(.semiBold, size: 18))
                                NavigationLink {
                                    Votice.feedbackNavigationView(theme: Votice.systemThemeWithCurrentFonts())
                                } label: {
                                    Text("Navigate to Feedback")
                                        .font(.poppins(.medium, size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.brand)
                                        .cornerRadius(15)
                                }
                            }
                            VStack(spacing: 10) {
                                Text("Option 3: Custom Theme")
                                    .font(.poppins(.semiBold, size: 18))
                                Button {
                                    showingFeedbackSheetWithCustomTheme = true
                                } label: {
                                    Text("Feedback with Custom Theme")
                                        .font(.poppins(.medium, size: 16))
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(.brand)
                                        .cornerRadius(15)
                                }
                            }
                        }
                        Spacer()
                        ReadyView(isConfigured: $isConfigured)
                            .padding(.bottom, 20)
                    }
                    .frame(minHeight: proxy.size.height)
                    .navigationTitle("Votice Demo")
                    .navigationBarTitleDisplayMode(.inline)
                }
                .scrollBounceBehavior(.basedOnSize)
                .scrollDismissesKeyboard(.immediately)
            }
        }
        .onAppear {
            configureVotice()

            // Optional: Configure custom texts for localization.
            // configureText()
        }
        .sheet(isPresented: $showingFeedbackSheet) {
            Votice.feedbackView(theme: Votice.systemThemeWithCurrentFonts())
        }
        .sheet(isPresented: $showingFeedbackSheetWithCustomTheme) {
            // Custom theme with Poppins fonts applied
            let customTheme = Votice.createThemeWithCurrentFonts(
                primaryColor: .red,
                backgroundColor: Color(.systemBackground),
                surfaceColor: Color(.secondarySystemBackground)
            )

            Votice.feedbackView(theme: customTheme)
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
            Votice.setDebugLogging(enabled: true)
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
