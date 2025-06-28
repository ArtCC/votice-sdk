//
//  HomeView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//

import SwiftUI
import Votice

struct HomeView: View {
    // MARK: - Properties

    @State private var showingFeedbackSheet = false
    @State private var showingEmbeddedView = false
    @State private var isConfigured = false

    // MARK: - View

    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                // Header
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

                // Demo Options
                VStack(spacing: 20) {
                    // Option 1: Sheet/Modal
                    VStack(spacing: 8) {
                        Text("Option 1: Modal Presentation")
                            .font(.headline)
                        Button("Show Feedback Sheet") {
                            showingFeedbackSheet = true
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }

                    // Option 2: Navigation
                    VStack(spacing: 8) {
                        Text("Option 2: Navigation Push")
                            .font(.headline)
                        NavigationLink("Navigate to Feedback") {
                            Votice.feedbackView()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }

                    // Option 3: Embedded View Toggle
                    VStack(spacing: 8) {
                        Text("Option 3: Embedded View")
                            .font(.headline)
                        Button(showingEmbeddedView ? "Hide Embedded View" : "Show Embedded View") {
                            showingEmbeddedView.toggle()
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                    }

                    // Option 4: SDK Button Component
                    VStack(spacing: 8) {
                        Text("Option 4: SDK Button Component")
                            .font(.headline)
                        Votice.feedbackButton(title: "Give Feedback 💡")
                    }

                    // Custom Theme Example
                    VStack(spacing: 8) {
                        Text("Option 5: Custom Theme")
                            .font(.headline)
                        Button("Feedback with Custom Theme") {
                            // This will be handled by the sheet with custom theme
                            showingFeedbackSheet = true
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.large)
                        .tint(.purple)
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
            }
            .padding()
            .navigationTitle("Votice Demo")
            .navigationBarTitleDisplayMode(.inline)
        }
        // Show embedded view when toggled
        .sheet(isPresented: $showingEmbeddedView) {
            NavigationView {
                Votice.feedbackView()
                    .navigationTitle("Embedded Feedback")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                showingEmbeddedView = false
                            }
                        }
                    }
            }
        }
        // Show feedback sheet
        .sheet(isPresented: $showingFeedbackSheet) {
            // Custom theme example
            let customTheme = Votice.createTheme(
                primaryColor: .purple,
                backgroundColor: Color(.systemBackground),
                surfaceColor: Color(.secondarySystemBackground)
            )

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
                apiKey: "101769679e916ab73153f290",
                apiSecret: "ef17a3f32faa587429830d59bc79db7b5b5466b8df1d62ae",
                appId: "1oSa2icpFbGk7M6hcKkW"
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
