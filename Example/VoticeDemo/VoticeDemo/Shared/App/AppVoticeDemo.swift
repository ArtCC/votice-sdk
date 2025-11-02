//
//  AppVoticeDemo.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

@main
struct AppVoticeDemo: App {
    // MARK: - Scene

    var body: some Scene {
        WindowGroup {
            HomeView()
#if os(macOS)
                .frame(minWidth: 1280, minHeight: 720)
#endif
        }
    }
}
