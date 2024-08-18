//
//  RatagochiApp.swift
//  Ratagochi
//
//  Created by Enzo Maruffa Moreira on 02/08/24.
//

import SwiftUI

@main
struct RatagochiApp: App {
    @StateObject private var appState = AppState()
    @StateObject private var ratRepository = RatRepository()
    
    init() {
        Logger.configure()
        Logger.info("RatagochiApp is starting up")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environmentObject(ratRepository)
                .onAppear {
                    appState.loadInitialState()
                }
        }
    }
}
