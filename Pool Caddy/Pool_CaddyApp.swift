//
//  Pool_CaddyApp.swift
//  Pool Caddy
//
//  Created by Cameron Grigoriadis on 12/21/21.
//

import SwiftUI

@main
struct Pool_CaddyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
