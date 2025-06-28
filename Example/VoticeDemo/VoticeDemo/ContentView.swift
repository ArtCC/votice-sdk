//
//  ContentView.swift
//  VoticeDemo
//
//  Created by Arturo Carretero Calvo on 27/6/25.
//

import SwiftUI
import Votice

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear {
            do {
                try Votice.configure(
                    apiKey: "101769679e916ab73153f290", apiSecret: "ef17a3f32faa587429830d59bc79db7b5b5466b8df1d62ae"
                )
            } catch {
                debugPrint("Configuration failed: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
}
