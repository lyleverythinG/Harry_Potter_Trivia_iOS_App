//
//  Harry_Potter_Trivia_iOS_AppApp.swift
//  Harry_Potter_Trivia_iOS_App
//
//  Created by Lyle Dane Carcedo on 12/16/24.
//

import SwiftUI

@main
struct Harry_Potter_Trivia_iOS_AppApp: App {
    @StateObject private var store = Store()
    @StateObject private var game = Game()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .environmentObject(game)
                .task {
                    await store.loadProducts()
                }
        }
    }
}
