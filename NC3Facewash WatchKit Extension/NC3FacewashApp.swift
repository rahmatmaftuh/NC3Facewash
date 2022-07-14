//
//  NC3FacewashApp.swift
//  NC3Facewash WatchKit Extension
//
//  Created by Rahmat Maftuh Ihsan on 14/07/22.
//

import SwiftUI

@main
struct NC3FacewashApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
