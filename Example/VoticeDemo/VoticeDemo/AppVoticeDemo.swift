//
//  AppVoticeDemo.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

#warning("Votice SDK is currently only supported on iOS and iPadOS. Support for macOS and tvOS will be available in future releases.")
@main
struct AppVoticeDemo: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
