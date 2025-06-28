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
            Votice.initialize()
        }
    }
}

#Preview {
    ContentView()
}
