//
//  RatagochiApp.swift
//  Ratagochi WatchKit Extension
//
//  Created by Daniella Onishi on 20/01/22.
//

import SwiftUI

@main
struct RatagochiApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
