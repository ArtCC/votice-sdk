//
//  AppVoticeDemo.swift
//  VoticeDemo_tvOS
//
//  Created by Arturo Carretero Calvo on 29/6/25.
//  Copyright © 2025 ArtCC. All rights reserved.
//

import SwiftUI

#warning("⚠ Votice SDK is currently only supported on iOS, iPadOS and macOS. Support for tvOS will be available in future releases.")
@main
struct AppVoticeDemo: App {
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
