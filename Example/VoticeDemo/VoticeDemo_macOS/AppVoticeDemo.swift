//
//  AppVoticeDemo.swift
//  VoticeDemo_macOS
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

@main
struct AppVoticeDemo: App {
    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            HomeView()
                .frame(minWidth: 800, minHeight: 600)
        }
    }
}
